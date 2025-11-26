use strict;
use warnings;

package Notifier;
sub send{
    die "method must be implemented"
}
sub get_message{
    die "method must be implemented"
}
1;

package BaseNotifier;
our @ISA = ('Notifier');
sub new{
    my ($class) = @_;
    my $self = {
        message => '',
        sender => 'System',
    };
    bless $self, $class;
    return $self;
}
sub send{
    my ($self) = @_;
    print "[$self->{sender}] $self->{message}\n"
}
sub get_message{
    my ($self) = @_;
    return $self->{message};
}
sub set_message{
    my ($self, $msg) = @_;
    $self->{message} = $msg;
}
1;

package NotifierDecorator;
our @ISA = ('Notifier');
sub new{
    my ($class, $notifier) = @_;
    my $self = {
        notifier => $notifier
    };
    bless $self, $class;
    return $self;
}
sub send{
    my ($self) = @_;
    $self->{notifier}->send();
}
sub get_message{
    my ($self) = @_;
    return $self->{notifier}->get_message();
}
1;

package EmailNotifier;
our @ISA = ('NotifierDecorator');
sub new{
    my ($class, $notifier, $email) = @_;
    my $self = $class->SUPER::new($notifier);
    $self->{email} = $email;
    bless $self, $class;
    return $self;
}
sub send{
    my ($self) = @_;
    $self->SUPER::send();
    if($self->{email} =~ /\@.+\./){
        print "send to email $self->{email} || " . $self->get_message() . "\n";
    }else{
        print "incorrect email [$self->{email}]\n"
    }
}
1;

package SMSNotifier;
our @ISA = ('NotifierDecorator');
sub new{
    my ($class, $notifier, $phone) = @_;
    my $self = $class->SUPER::new($notifier);
    $self->{phone} = $phone;
    bless $self, $class;
    return $self;
}
sub send{
    my ($self) = @_;
    $self->SUPER::send();
    if($self->{phone} =~ /^\d{10}$/){
        print "send to phone number $self->{phone} || " . $self->get_message() . "\n";
    }else{
        print "incorrect phone number [$self->{phone}]\n"
    }
}
1;

package LineNotifier;
our @ISA = ('NotifierDecorator');
sub new{
    my ($class, $notifier, $line_id) = @_;
    my $self = $class->SUPER::new($notifier);
    $self->{line_id} = $line_id;
    bless $self, $class;
    return $self;
}
sub send{
    my ($self) = @_;
    $self->SUPER::send();
    print "send to line id $self->{line_id} || " . $self->get_message() . "\n";
}
1;


my $notifier = BaseNotifier->new();
$notifier->set_message("wee~");
$notifier->send();

my $Enotifier = EmailNotifier->new($notifier, "user\@gmail.com");
print "\n";
$Enotifier->send();

my $ESnotifier = SMSNotifier->new($Enotifier, "0894562564");
print "\n";
$ESnotifier->send();

my $ESLnotifier = LineNotifier->new($ESnotifier, "line_user");
print "\n";
$ESLnotifier->send();

