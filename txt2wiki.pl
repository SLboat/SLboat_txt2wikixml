#!/usr/bin/perl -w
# mediawiki转wiki脚本
# 原始版本来自http://php.ptagis.org/wiki/index.php/Txt2wiki.pl

# 森亮号改造内容：
## 增加支持mediawiki的0.8XML语法

# 发现
## 看起来它是给每个文件转换一个xml-太傻了 

# todo 
## 格式完善
## 整理大量mediawiki文件-那就不需要多个头部了吧
## 处理掉文本乱码啥子的
## 支持中文文件-非常重要

use HTML::Entities;

my $indir = `pwd`;

# 测试模式-加上本地地址
# $indir = '/Users/sen/tools/txt2wiki/xml_text/';

# 这是做了啥
chomp $indir;
my $infile;
my $outfile;
my $title;
my $comment = '来自TextMate的见识建造!由mediawiki2wiki.pl生产xml。';
# 处理了几个文件
my $counts = 0;

# 提醒开始干活
print "\nStart work with the txt file...\n\n";

opendir(INDIR, $indir) || die "couldn't open $indir for reading";

while($infile = readdir(INDIR)) {
	next if ($infile =~ /^\./);
	# 这里是直接跳过已知的
	next if ($infile =~ /xml$/);
	print "found $infile...\n";
	# 输出文件更改后缀
	$outfile = $infile;
	$outfile =~ s/mediawiki$/xml/;
	# 提示开始输出
	print "switch to $outfile\n";
	#反向死亡,死亡是全部退出这很糟糕-或许只需要退出while就够了
	# 在上面已经判断了
	next unless ($outfile =~ m/xml$/);
	
	# 截取标题
	$title = $infile;
	$title =~ s/\.mediawiki$//;

	open(IN, "$infile") || die "couldn't open $infile for read";
	# 打开输出流，这里很像管道呢
	open(OUT, ">$outfile") || die "couldn't open $outfile for write";
	&printheader();
	# 这是转换每一个字节吧
	while (<IN>) {
		#print "read a line from $infile\n";
		print OUT encode_entities($_, '<>&"\'');
	}
	&printfooter();
	# 关闭所有输出
	close(IN);
	close(OUT);
	print "converted $outfile...\n";
	# 好了加一也不错
	$counts++;
}
# 关闭目录-为啥要关闭呢
closedir(INDIR);

print "\njust done the work!with $counts file\n\n";

# 开始输出头部
sub printheader {
	print OUT <<EOF;
	<mediawiki version="0.8" xml:lang="zh-cn">

		<page>
			<title>$title</title>
			<revision>
				<contributor><username>SLboat's SeaBot</username></contributor>
				<comment>$comment</comment>
				<text>
EOF
}

# 最后输出尾巴
sub printfooter {
	print OUT <<EOF;
			</text>
		</revision>
	</page>
  
</mediawiki>

EOF
}

