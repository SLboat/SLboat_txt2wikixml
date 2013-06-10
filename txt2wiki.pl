#!/usr/bin/perl -w
# mediawiki转wiki脚本
#原始版本来自http://php.ptagis.org/wiki/index.php/Txt2wiki.pl

# 森亮号改造内容：
## 增加支持mediawiki的0.8XML语法
## 一次性获得所有文件

# todo 
## 处理掉文本乱码啥子的
## 支持中文文件-非常重要-是的完全支持
## title支持过滤xml字符
## 添加每次提交信息为某次提交


use HTML::Entities;

my $indir = `pwd`;

# 测试模式-加上本地地址
# $indir = '/Users/sen/tools/txt2wiki/xml_text/';

print "\t森亮号见识整合水手\t\n";

# 这是做了啥-去除了换行字符等东西
chomp $indir;
my $infile;
my $outfile;
my $title;
my $comment = '来自TextMate的见识建造!由mediawiki2wiki.pl生产xml';
# 处理了几个文件
my $counts = 0;
# 最终固定输出文件名
$outfile = "SLboat_SEEING.xml";
# 提醒开始干活
print "\n开始整合见识文件...\n\n";

# 先打开了目录-看起来是
opendir(INDIR, $indir) || die "couldn't open $indir for reading";

# 打开输出流，这里很像管道呢
open(OUT, ">$outfile") || die "couldn't open $outfile for write";
# 输出头部
&printxmlheader();
# 读取检查每一个文件
while($infile = readdir(INDIR)) {
	# 没有后缀[.]除掉
	next if ($infile =~ /^\./);
	# 这里是直接跳过已知的
	next if ($infile =~ /xml$/);
	# 提示开始输出
	#反向死亡,死亡是全部退出这很糟糕-或许只需要退出while就够了
	# 判断是否有效的待转换格式文件
	next unless ($infile =~ m/mediawiki$/);
	
	# 截取标题
	$title = $infile;
	# s模式替换源字符串为空白
	$title =~ s/\.mediawiki$//;
	# 替换回去mac的冒号
	$title =~ s/\:/\\/;
	print "\t正在整合第".($counts+1)."个见识: $title\n";
	# 处理输入文件
	open(IN, "$infile") || die "无法打开$infile来进行读取";

	&printpagehead ();
	# 这是转换每一个字节吧
	while (<IN>) {
		#print "read a line from $infile\n";
		print OUT encode_entities($_, '<>&"\'');
	}
	&printpagefooter();
	# 关闭所有输出
	close(IN);
	# print "converted $outfile...\n";
	# 好了加一也不错
	$counts++;
}
# 输出尾巴部分
&printxmlfooter();
# 最终关闭文件
close(OUT);
# 关闭目录-为啥要关闭呢
closedir(INDIR);
# 告别
print "\n整合见识完毕!这次一共整合了$counts个见识文件\n它们被放置于: $outfile\n\n";

# todo:使用函数一样的玩意改写-page::head
# page的额头-不能有换行
sub printpagehead{
	chomp(my $string_out = <<EOF);
		<page>
			<title>$title</title>
			<revision>
				<contributor><username>SLboat's SeaBot</username></contributor>
				<comment>$comment</comment>
				<text>
EOF
	#最终输出
	print OUT $string_out;
}

# page的尾巴-多个换行尾巴，看起来没坏处
sub printpagefooter{
	my $string_out = <<EOF;
	
				</text>
			</revision>
		</page>
EOF
	print OUT $string_out;
}

# xml输出头部
sub printxmlheader {
	print OUT <<EOF;
<mediawiki version="0.8" xml:lang="zh-cn">
	
EOF
}

# xml输出尾巴
sub printxmlfooter {
	print OUT <<EOF;
	
</mediawiki>
EOF
}

