// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public struct StatUpdateInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - date
  ///   - quantity
  ///   - key
  public init(date: String, quantity: Double, key: String) {
    graphQLMap = ["date": date, "quantity": quantity, "key": key]
  }

  public var date: String {
    get {
      return graphQLMap["date"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "date")
    }
  }

  public var quantity: Double {
    get {
      return graphQLMap["quantity"] as! Double
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "quantity")
    }
  }

  public var key: String {
    get {
      return graphQLMap["key"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "key")
    }
  }
}

public struct LoginInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - email
  ///   - password
  public init(email: String, password: String) {
    graphQLMap = ["email": email, "password": password]
  }

  public var email: String {
    get {
      return graphQLMap["email"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "email")
    }
  }

  public var password: String {
    get {
      return graphQLMap["password"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "password")
    }
  }
}

public final class AddStatMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation addStat($statsToAdd: [StatUpdateInput!]!) {
      update_stats(data: $statsToAdd)
    }
    """

  public let operationName: String = "addStat"

  public var statsToAdd: [StatUpdateInput]

  public init(statsToAdd: [StatUpdateInput]) {
    self.statsToAdd = statsToAdd
  }

  public var variables: GraphQLMap? {
    return ["statsToAdd": statsToAdd]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("update_stats", arguments: ["data": GraphQLVariable("statsToAdd")], type: .nonNull(.scalar(Bool.self))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(updateStats: Bool) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "update_stats": updateStats])
    }

    public var updateStats: Bool {
      get {
        return resultMap["update_stats"]! as! Bool
      }
      set {
        resultMap.updateValue(newValue, forKey: "update_stats")
      }
    }
  }
}

public final class LoginMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation Login($login: LoginInput!) {
      login(data: $login) {
        __typename
        token
        user {
          __typename
          firstname
          lastname
        }
      }
    }
    """

  public let operationName: String = "Login"

  public var login: LoginInput

  public init(login: LoginInput) {
    self.login = login
  }

  public var variables: GraphQLMap? {
    return ["login": login]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("login", arguments: ["data": GraphQLVariable("login")], type: .nonNull(.object(Login.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(login: Login) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "login": login.resultMap])
    }

    public var login: Login {
      get {
        return Login(unsafeResultMap: resultMap["login"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "login")
      }
    }

    public struct Login: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Auth"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("token", type: .nonNull(.scalar(String.self))),
        GraphQLField("user", type: .nonNull(.object(User.selections))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(token: String, user: User) {
        self.init(unsafeResultMap: ["__typename": "Auth", "token": token, "user": user.resultMap])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// JWT Bearer token
      public var token: String {
        get {
          return resultMap["token"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "token")
        }
      }

      public var user: User {
        get {
          return User(unsafeResultMap: resultMap["user"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "user")
        }
      }

      public struct User: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["User"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("firstname", type: .scalar(String.self)),
          GraphQLField("lastname", type: .scalar(String.self)),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(firstname: String? = nil, lastname: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "User", "firstname": firstname, "lastname": lastname])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var firstname: String? {
          get {
            return resultMap["firstname"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "firstname")
          }
        }

        public var lastname: String? {
          get {
            return resultMap["lastname"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "lastname")
          }
        }
      }
    }
  }
}

public final class MainDashboardQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query MainDashboard($date: String!) {
      me {
        __typename
        firstname
        lastname
        avatar
      }
      stats(startDate: $date, first: 1) {
        __typename
        nodes {
          __typename
          weight
        }
      }
    }
    """

  public let operationName: String = "MainDashboard"

  public var date: String

  public init(date: String) {
    self.date = date
  }

  public var variables: GraphQLMap? {
    return ["date": date]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("me", type: .nonNull(.object(Me.selections))),
      GraphQLField("stats", arguments: ["startDate": GraphQLVariable("date"), "first": 1], type: .nonNull(.object(Stat.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(me: Me, stats: Stat) {
      self.init(unsafeResultMap: ["__typename": "Query", "me": me.resultMap, "stats": stats.resultMap])
    }

    public var me: Me {
      get {
        return Me(unsafeResultMap: resultMap["me"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "me")
      }
    }

    public var stats: Stat {
      get {
        return Stat(unsafeResultMap: resultMap["stats"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "stats")
      }
    }

    public struct Me: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["User"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("firstname", type: .scalar(String.self)),
        GraphQLField("lastname", type: .scalar(String.self)),
        GraphQLField("avatar", type: .scalar(String.self)),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(firstname: String? = nil, lastname: String? = nil, avatar: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "User", "firstname": firstname, "lastname": lastname, "avatar": avatar])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var firstname: String? {
        get {
          return resultMap["firstname"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "firstname")
        }
      }

      public var lastname: String? {
        get {
          return resultMap["lastname"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "lastname")
        }
      }

      public var avatar: String? {
        get {
          return resultMap["avatar"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "avatar")
        }
      }
    }

    public struct Stat: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["StatsConnection"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("nodes", type: .list(.nonNull(.object(Node.selections)))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(nodes: [Node]? = nil) {
        self.init(unsafeResultMap: ["__typename": "StatsConnection", "nodes": nodes.flatMap { (value: [Node]) -> [ResultMap] in value.map { (value: Node) -> ResultMap in value.resultMap } }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var nodes: [Node]? {
        get {
          return (resultMap["nodes"] as? [ResultMap]).flatMap { (value: [ResultMap]) -> [Node] in value.map { (value: ResultMap) -> Node in Node(unsafeResultMap: value) } }
        }
        set {
          resultMap.updateValue(newValue.flatMap { (value: [Node]) -> [ResultMap] in value.map { (value: Node) -> ResultMap in value.resultMap } }, forKey: "nodes")
        }
      }

      public struct Node: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Stats"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("weight", type: .scalar(Double.self)),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(weight: Double? = nil) {
          self.init(unsafeResultMap: ["__typename": "Stats", "weight": weight])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var weight: Double? {
          get {
            return resultMap["weight"] as? Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "weight")
          }
        }
      }
    }
  }
}
