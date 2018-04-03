#    M              OOOOOOOO
#    A            OO--------OO
#    D          OO--------VVVVOO
#    E        OOVVVV------VVVVVVOO
#             OOVVVV------VVVVVVOO
#    B      OOVVVVVV--------VVVV--OO
#    Y      OOVVVVVV--------------OO
#         OO----------VVVVVV--------OO
#    O    OO--------VVVVVVVVVV------OO
#    V    OOVVVV----VVVVVVVVVV------OO
#    O    OOVVVVVV--VVVVVVVVVV--VV--OO
#    K      OOVVVV----VVVVVV--VVVVOO
#    O      OOVVVV------------VVVVOO
#    R        OOOO--------------OO
#    E            OO--------OOOO
#    !              OOOOOOOO

use strict;

sub derivar {
	my ($a) = @_;
	my $return;
	while ($a =~ s/^([^*]+\*\*[\w]+)//gm) {
		$return = "$return" . derivar1($1);
	}
	if ($a =~ s/^([^x]+x)//gm)  {
		$return = "$return" . derivar1($1);
	}
	if ($a =~ s/^([+|-]\d+)//gm) {
		$return = "$return" . derivar1($1);
	}
	if (length($a) == 0) {
		return $return;
	}
	return 0;
}

sub derivar1 {
	my ($a) = @_;
	$a =~ /^([+|-])?([\d]*)(x)?(\*\*)?(\d)*$/;
	if (!$2 && $3 eq 'x' && $4 eq '**' && $5 > 1) {
		if (($5 - 1) == 1) {
			return "$1$5x";
		}
		else {
			return "$1$5x\*\*" . ($5 - 1);
		}
	}
	elsif ($2 > 0 && $3 eq 'x' && $4 eq '**' && $5 > 1) {
		if (($5 - 1) == 1) {
			return "$1" . ($2 * $5) . 'x';
		}
		else {
			return "$1" . ($2 * $5) . 'x**' . ($5 - 1);
		}
	}
	elsif (!$2 && $3 eq 'x' && !$4) {
		return "$1" . "1";
	}
	elsif ($2 > 0 && $3 eq 'x' && !$4) {
		return "$1$2";
	}
}

sub valor {
	my ($a, $b) = @_;
	$a =~ s/(\d)+x\*\*(\d)+/\(($1\*\($b\)\)\*\*$2\)/gm;
	$a =~ s/x\*\*(\d)+/(\($b\)\*\*$1\)/gm;
	$a =~ s/(\d)+x/\($1\*\($b\)\)/gm;
	$a =~ s/(x)/\($b\)/gm;
	return $a;
}

print "Exemplo:\n\t2x**3+6x**2-6x+9\n\t-6x**3+x-9\n";
print "Digite a funcao:\n\t";
my $funcao = <STDIN>;
$funcao =~ s/\n//gm;
if (derivar($funcao) != 0) {
	print "Digite o valor de x:\n\t";
	my $get = <STDIN>;
	$get =~ s/\n//gm;
	my @x;
	push @x, $get;
	my $cont = 0;
	open (my $write, '>:encoding(UTF-8)', 'top3.txt');
	print $write "f = $funcao\nf' = " . derivar($funcao);
	for (my $i = 0;$i < 100000; $i++) {
		my $valorFuncao = valor($funcao, $x[$cont]);
		my $valorDerivada = valor(derivar($funcao), $x[$cont]);
		print $write "\n\nx($cont) = $x[$cont]\nf($cont) = $valorFuncao\nf'($cont) = $valorDerivada";		
		push @x, eval("$x[$cont] - ($valorFuncao) / ($valorDerivada)");
		$cont++;
		if (($x[$cont] <= 0.0001 && $x[$cont] >= -0.0001)) {
			print $write "\n\nx($cont) = $x[$cont]";
			last;
		}
		elsif ($x[$cont] == $x[$cont-1]) {
			last;
		}
	}
	close $write;
}

#Letícia, para de mimimi! Eu te amo!