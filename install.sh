dnf install -y wget rpmdevtools rpm-build createrepo yum-utils cmake gcc git nano
mkdir rpm && cd rpm && yumdownloader --source nginx
rpm -Uvh nginx*.src.rpm && yum-builddep nginx -y
cd /root && git clone --recurse-submodules -j8 https://github.com/google/ngx_brotli
cd ngx_brotli/deps/brotli && mkdir out && cd out
cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DCMAKE_C_FLAGS="-Ofast -m64 -march=native -mtune=native -flto -funroll-loops -ffunction-sections -fdata-sections -Wl,--gc-sections" -DCMAKE_CXX_FLAGS="-Ofast -m64 -march=native -mtune=native -flto -funroll-loops -ffunction-sections -fdata-sections -Wl,--gc-sections" -DCMAKE_INSTALL_PREFIX=./installed ..
cmake --build . --config Release -j 2 --target brotlienc
sed -i '/    --with-compat \\/a \\t --add-module=\\/root\/ngx_brotli \\' ~/rpmbuild/SPECS/nginx.spec
cd ~/rpmbuild/SPECS/ && rpmbuild -ba nginx.spec -D 'debug_package %{nil}'
cp ~/rpmbuild/RPMS/noarch/* ~/rpmbuild/RPMS/x86_64/
cd /root/rpmbuild/RPMS/x86_64/ && dnf localinstall *.rpm -y
mkdir /usr/share/nginx/html/repo/
cp ~/rpmbuild/RPMS/x86_64/*.rpm /usr/share/nginx/html/repo/
createrepo /usr/share/nginx/html/repo/
sed -i '/root         \/usr\/share\/nginx\/html;/a \\t index index.html index.htm;' /etc/nginx/nginx.conf
sed -i '/index index.html index.htm;/a \\t autoindex on;' /etc/nginx/nginx.conf
systemctl restart nginx