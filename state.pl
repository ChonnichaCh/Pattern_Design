use strict;
use warnings;

package Monster;
sub new{
    my ($class) = @_;
    my $self = {
        health => 100,
        state => undef,
    };
    bless $self, $class;
    $self->{state} = Patrolling->new($self, "forest");
    return $self;
}
sub setState{
    my($self, $state) = @_;
    $self->{state} = $state;
}
sub getState{
    my($self) = @_;
    return ref($self->{state})
}
sub found_player{
    my ($self, $distance) = @_;
    $self->{state}->found_player($distance);
}
sub found_monster{
    my ($self, $monster) = @_;
    $self->{state}->found_monster($monster);
}
sub found_animal{
    my ($self, $distance, $animal) = @_;
    $self->{state}->found_animal($distance, $animal);
}
sub getHealth{
    my ($self) = @_;
    return $self->{health};
}
sub setHealth{
    my($self, $health) = @_;
    $self->{health} = $health;
}

package State;
sub new{
    my ($class, $monster) = @_;
    my $self = {monster => $monster};
    bless $self, $class;
    return $self;
}
sub found_player{die "this method must be implemented"}
sub found_monster{die "this method must be implemented"}
sub found_animal{die "this method must be implemented"}

package Patrolling;
use base 'State';
sub new{
    my ($class, $monster, $area) = @_;
    my $self = $class->SUPER::new($monster);
    $self->{area} = $area;
    return $self;
}
sub found_player{
    my ($self, $distance) = @_;
    print "Patrolling ".$self->{area}." found player distance : $distance (health : ".$self->{monster}->{health}.")\n";
    if($distance<10){
        $self->{monster}->setState(Attacking->new($self->{monster}, 5));
        print "     Monster is Attacking!!! (power 5)\n";
    }elsif($distance<50){
        $self->{monster}->setState(Chasing->new($self->{monster}, 10));
        print "     Monster is Chasing the Player! (speed 10)\n";
    }
}
sub found_monster{
    my ($self, $monster) = @_;
    print "Patrolling ".$self->{area}." found monster state ".$monster->getState()."(health : ".$self->{monster}->{health}.")\n";
    if($monster->getState() eq "Fleeing"){
        $self->{monster}->setState(Fleeing->new($self->{monster}, 0.5));
        print "     Monster is Fleeing! (healing rate 0.5)\n";
    }elsif($monster->getState() eq "Chasing"){
        $self->{monster}->setState(Chasing->new($self->{monster}, 10));
        print "     Monster is Chasing the Player! (speed 10)\n";
    }elsif($monster->getState() eq "Attacking"){
        $self->{monster}->setState(Attacking->new($self->{monster}, 5));
        print "     Monster is Attacking!!! (power 5)\n";
    }
}
sub found_animal{
    my ($self, $distance, $animal) = @_;
    print "Patrolling ".$self->{area}." found $animal distance : $distance (health : ".$self->{monster}->{health}.")\n";
    if($animal eq "Dinosaur" && $distance<50){
        $self->{monster}->setState(Fleeing->new($self->{monster}, 0.5));
        print "     Monster is Fleeing! (healing rate 0.5)\n";
    }elsif($animal eq "Chicken"){
        if($distance<10){
            $self->{monster}->setState(Attacking->new($self->{monster}, 5));
            print "     Monster is Attacking!!! (power 5)\n";
        }elsif($distance<50){
            $self->{monster}->setState(Chasing->new($self->{monster}, 10));
            print "     Monster is Chasing the Chicken! (speed 10)\n";
        }
    }
}

package Chasing;
use base 'State';
sub new{
    my ($class, $monster, $speed) = @_;
    my $self = $class->SUPER::new($monster);
    $self->{speed} = $speed;
    return $self;
}
sub found_player{
    my ($self, $distance) = @_;
    print "Chasing speed ".$self->{speed}." distance : $distance (health : ".$self->{monster}->{health}.")\n";
    if($distance>50){
        $self->{monster}->setState(Patrolling->new($self->{monster}, "forest"));
        print "     Monster is Patrolling... (forest)\n";
    }elsif($distance<10){
        $self->{monster}->setState(Attacking->new($self->{monster}, 5));
        print "     Monster is Attacking!!! (power 5)\n";
    }elsif($self->{monster}->getHealth()<30){
        $self->{monster}->setState(Fleeing->new($self->{monster}, 0.5));
        print "     Monster is Fleeing! (healing rate 0.5)\n";
    }
}
sub found_monster{
    my ($self, $monster) = @_;
    print "Chasing speed ".$self->{speed}." found monster state ".$monster->getState()."(health : ".$self->{monster}->{health}.")\n";
    if($monster->getState() eq "Fleeing"){
        $self->{monster}->setState(Fleeing->new($self->{monster}, 0.5));
        print "     Monster is Fleeing! (healing rate 0.5)\n";
    }elsif($monster->getState() eq "Attacking"){
        $self->{monster}->setState(Attacking->new($self->{monster}, 5));
        print "     Monster is Attacking!!! (power 5)\n";
    }
}
sub found_animal{
    my ($self, $distance, $animal) = @_;
    print "Chasing speed ".$self->{speed}." found $animal distance : $distance (health : ".$self->{monster}->{health}.")\n";
    if($animal eq "Dinosaur"){
        $self->{monster}->setState(Fleeing->new($self->{monster}, 0.5));
        print "     Monster is Fleeing! (healing rate 0.5)\n";
    }elsif($animal eq "Chicken"){
        if($distance>50){
            $self->{monster}->setState(Patrolling->new($self->{monster}, "forest"));
            print "     Monster is Patrolling... (forest)\n";
        }elsif($distance<10){
            $self->{monster}->setState(Attacking->new($self->{monster}, 5));
            print "     Monster is Attacking!!! (power 5)\n";
        }
    }
}

package Attacking;
use base 'State';
sub new{
    my ($class, $monster, $power) = @_;
    my $self = $class->SUPER::new($monster);
    $self->{power} = $power;
    return $self;
}
sub found_player{
    my ($self, $distance) = @_;
    print "Attacking power ".$self->{power}." distance : $distance (health : ".$self->{monster}->{health}.")\n";
    $self->{monster}->setHealth(20);
    if($self->{monster}->getHealth()<30){
        $self->{monster}->setState(Fleeing->new($self->{monster}, 0.5));
        print "     Monster is Fleeing! (healing rate 0.5)\n";
    }elsif($distance>10){
        $self->{monster}->setState(Chasing->new($self->{monster}, 15));
        print "     Monster is Chasing the Player! (speed 15)\n";
    }
}
sub found_monster{
    my ($self, $monster) = @_;
    print "Attacking power ".$self->{power}." found monster state ".$monster->getState()."(health : ".$self->{monster}->{health}.")\n";
    if($monster->getState() eq "Fleeing"){
        $self->{monster}->setState(Fleeing->new($self->{monster}, 0.5));
        print "     Monster is Fleeing! (healing rate 0.5)\n";
    }
}
sub found_animal{
    my ($self, $distance, $animal) = @_;
    print "Attacking power ".$self->{power}." found $animal distance : $distance (health : ".$self->{monster}->{health}.")\n";
    if($animal eq "Dinosaur"){
        $self->{monster}->setState(Fleeing->new($self->{monster}, 0.5));
        print "     Monster is Fleeing! (healing rate 0.5)\n";
    }elsif($animal eq "Chicken"){
        if($self->{monster}->getHealth()<30){
            $self->{monster}->setState(Fleeing->new($self->{monster}, 0.5));
            print "     Monster is Fleeing! (healing rate 0.5)\n";
        }elsif($distance>10){
            $self->{monster}->setState(Chasing->new($self->{monster}, 15));
            print "     Monster is Chasing the Chicken! (speed 15)\n";
        }
    }
}

package Fleeing;
use base 'State';
sub new{
    my ($class, $monster, $rate) = @_;
    my $self = $class->SUPER::new($monster);
    $self->{healingRate} = $rate;
    return $self;
}
sub found_player{
    my ($self, $distance) = @_;
    print "Fleeing and heal ".$self->{healingRate}." per minute. Distance : $distance (health : ".$self->{monster}->{health}.")\n";
    $self->{monster}->setHealth(100*$self->{healingRate});
    if($distance>50){
        $self->{monster}->setState(Patrolling->new($self->{monster}, "village"));
        print "     Monster is Patrolling... (village)\n";
    }
}
sub found_monster{
    my ($self, $monster) = @_;
    print "Fleeing and heal ".$self->{healingRate}." per minute. Found monster state ".$monster->getState()."(health : ".$self->{monster}->{health}.")\n";
    if($monster->getState() eq "Patrolling"){
        $self->{monster}->setState(Patrolling->new($self->{monster}, "village"));
        print "     Monster is Patrolling... (village)\n";
    }
}
sub found_animal{
    my ($self, $distance, $animal) = @_;
    print "Fleeing and heal ".$self->{healingRate}." per minute. Found $animal distance : $distance (health : ".$self->{monster}->{health}.")\n";
    if($distance>50){
        $self->{monster}->setState(Patrolling->new($self->{monster}, "village"));
        print "     Monster is Patrolling... (village)\n";
    }
}

package main;
print "Monster 1\n";
my $monster1 = Monster->new();
$monster1->found_player(40);
$monster1->found_player(55);
$monster1->found_player(5);
$monster1->found_player(15);
$monster1->found_player(20);
$monster1->found_player(70);
$monster1->found_player(20);
$monster1->getState();

print "\n\nMonster 2\n";
my $monster2 = Monster->new();
$monster2->found_monster($monster1);
$monster2->getState();

print "\n\nMonster 3\n";
my $monster3 = Monster->new();
$monster3->found_animal(40, "Dinosaur");
$monster3->found_animal(100, "Dinosaur");
$monster3->found_animal(20, "Chicken");
$monster3->getState();