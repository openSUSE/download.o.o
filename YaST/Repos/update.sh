for i in *.xml.in; do 
  intltool-extract --type=gettext/xml $i
done
svn up $MY_LCN_CHECKOUT/50-pot
xgettext -kN_ -o $MY_LCN_CHECKOUT/50-pot/community-repositories.pot *.h
svn diff $MY_LCN_CHECKOUT/50-pot/community-repositories.pot
svn ci $MY_LCN_CHECKOUT/50-pot/community-repositories.pot
rm *.h

svn up $MY_LCN_CHECKOUT
rm -rf po
mkdir po
for i in $MY_LCN_CHECKOUT/*/po/community-repositories*.po; do 
  file=`basename $i .po`
  file=${file/community-repositories./}
  cp $i po/$file.po
done

for i in *.xml; do 
  intltool-merge --xml-style po $i.in $i
done

svn ci -m "update translations"

rm -rf po

ssh root@ftp-opensuse.suse.de svn up /srv/www-local/download
