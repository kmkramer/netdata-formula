#!/bin/bash
#
# netdata        Startup script for netdata.
#
# chkconfig: 2345 12 88
# description: Real-time charts for system monitoring
### BEGIN INIT INFO
# Provides:          netdata
# Required-Start:    $remote_fs
# Required-Stop:     $remote_fs
# Should-Start:      $network
# Should-Stop:       $network
# Default-Start:     2 3 4 5
# Default-Stop:
# Short-Description: Real-time charts for system monitoring
# Description:       Netdata is a daemon that collects data in realtime (per second)
#                    and presents a web site to view and analyze them. The presentation
#                    is also real-time and full of interactive charts that precisely
#                    render all collected values.
### END INIT INFO

# Source function library.
. /etc/init.d/functions

RETVAL=0
PIDFILE=/var/run/netdata.pid

prog=netdata
uid=netdata
exec=/usr/sbin/netdata
lockfile=/var/lock/subsys/$prog

# Source config
if [ -f /etc/sysconfig/$prog ] ; then
    . /etc/sysconfig/$prog
fi

start() {
        [ -x $exec ] || exit 5

        umask 077

        echo -n $"Starting netdata monitoring: "
        daemon --pidfile="$PIDFILE" $exec -u $uid -pidfile $PIDFILE
        RETVAL=$?
        echo
        [ $RETVAL -eq 0 ] && touch $lockfile
        return $RETVAL
}
stop() {
        echo -n $"Shutting down netdata monitoring: "
        killproc -p "$PIDFILE" $exec
        RETVAL=$?
        echo
        [ $RETVAL -eq 0 ] && rm -f $lockfile
        return $RETVAL
}
rhstatus() {
        status -p "$PIDFILE" -l $prog $exec
}
restart() {
        stop
        start
}

case "$1" in
  start)
        start
        ;;
  stop)
        stop
        ;;
  restart)
        restart
        ;;
  reload)
        exit 3
        ;;
  force-reload)
        restart
        ;;
  status)
        rhstatus
        ;;
  condrestart|try-restart)
        rhstatus >/dev/null 2>&1 || exit 0
        restart
        ;;
  *)
        echo $"Usage: $0 {start|stop|restart|condrestart|try-restart|reload|force-reload|status}"
        exit 3
esac

exit $?
