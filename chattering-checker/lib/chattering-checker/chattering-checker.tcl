package provide chattering-checker 1.1

namespace eval Time {}

proc Time::to_s {pit fmt} {
	set sec [clock format [string range $pit 0 9] -format $fmt]
	set pre [string range $pit 10 end]
	expr {$pre == {} ? "$sec" : "$sec.$pre"}
}

proc stopwatch {e __prev __curr} {
	global prev
	upvar $__prev _prev
	upvar $__curr _curr
	
	set _curr [clock milliseconds]
	if {[info exists prev($e)]} {
		set _prev $prev($e)
		set elapsed [expr {$_curr-$_prev}]
	} else {
		set _prev 0
		set elapsed $_curr
	}
	
	set prev($e) $_curr
	
	return $elapsed
}

proc record {e} {
	set elapsed [stopwatch $e prev curr]
	if {$prev == 0} {
		set elp "first"
	} else {
		set elp "in $elapsed ms"
	}
	puts "[Time::to_s $curr %T] : $e ($elp)"
}

bind all <ButtonPress-1> {record ButtonPress-1}
bind all <ButtonRelease-1> {record ButtonRelease-1}

bind all <ButtonPress-3> {record ButtonPress-3}
bind all <ButtonRelease-3> {record ButtonRelease-3}

label .guide -text "Test mouse operation here."
place .guide -x 0 -y 0

console show
