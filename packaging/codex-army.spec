Name:           codex-army
Version:        0.0.0
Release:        1%{?dist}
Summary:        Codex Army CLI
License:        Apache-2.0
BuildArch:      x86_64

Requires:       glibc
Requires:       libcap2
Requires:       libgcc_s1
Requires:       libjitterentropy3
Requires:       libopenssl3
Requires:       libz1

%description
Codex Army CLI binary packaged from a local build.

%prep

%build

%install
install -Dm0755 %{_sourcedir}/codex-army %{buildroot}%{_bindir}/codex-army

%files
%{_bindir}/codex-army

%changelog
* Fri May 15 2026 Local Build <local@localhost> - 0.0.0-1
- Local codex-army package.

