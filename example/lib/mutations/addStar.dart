String gql(String input) => input;

String addStar = gql("""
  mutation AddStar(\$starrableId: ID!) {
    addStar(input: {starrableId: \$starrableId}) {
      starrable {
        viewerHasStarred
      }
    }
  }
""").replaceAll('\n', ' ');
