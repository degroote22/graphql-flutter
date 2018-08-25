String gql(String input) => input;

String readRepositories = gql("""
  query ReadRepositories {
    viewer {
      repositories(last: 50) {
        nodes {
          id
          name
          viewerHasStarred
        }
      }
    }
  }
""").replaceAll('\n', ' ');
