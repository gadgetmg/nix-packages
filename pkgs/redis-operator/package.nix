{
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "redis-operator";
  version = "3.3.3";
  src = fetchFromGitHub {
    owner = "freshworks-oss";
    repo = "redis-operator";
    rev = "v${version}";
    hash = "sha256-Dh9aStaYliZ4jd9XWOm7hE5jvxbNcAi+ZlzjochHwRg=";
  };
  vendorHash = "sha256-gXNX6hRmc+hstoiOSInKouzSISPjSbImjyCU1XD6h9o=";
  meta.mainProgram = "redisoperator";
}
