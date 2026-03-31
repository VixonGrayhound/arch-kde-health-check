# Maintainer: VixonGrayhound <vixon.gray@kitrmail.com>

pkgname=arch-kde-health-check
pkgver=1.0
pkgrel=1
pkgdesc="Arch Linux + KDE Plasma health check CLI tool"
arch=('any')
url="https://github.com/VixonGrayhound/arch-kde-health-check"
license=('MIT')
depends=('bash' 'pacman' 'systemd')
optdepends=(
  'mesa-utils: OpenGL info (glxinfo)'
  'vulkan-tools: Vulkan info (vulkaninfo)'
  'clinfo: OpenCL info'
  'rocm-opencl-runtime: ROCm OpenCL support'
  'rocm-hip-runtime: ROCm HIP support'
)
source=("https://github.com/VixonGrayhound/arch-kde-health-check/archive/refs/tags/v${pkgver}.tar.gz")
sha256sums=('bbde677815c6388fb0e23b3870dc69555d576d0edddcd80759ff5584eeae9395')

package() {
    install -Dm755 "$srcdir/$pkgname-$pkgver/arch_kde_health.sh" \
        "$pkgdir/usr/bin/arch-kde-health-check"
}
