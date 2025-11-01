{ pkgs }:
{
  agda = pkgs.mkShell {
    buildInputs = with pkgs; [ agda ];
  };
}
