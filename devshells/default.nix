{ pkgs }:
{
  agda = pkgs.mkShell {
    buildINputs = with pkgs; [ agda ];
  };
}
