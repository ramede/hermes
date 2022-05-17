/// A representation of a search cursor returned from GitHub used in pagination.
struct Cursor:
  RawRepresentable,
  ExpressibleByStringLiteral, ExpressibleByStringInterpolation
{
  let rawValue: String
  init(rawValue: String) { self.rawValue = rawValue }
  init(stringLiteral: String) { self.init(rawValue: stringLiteral) }
  init(stringInterpolation: String) { self.init(rawValue: stringInterpolation) }
}

extension SearchRepositoriesQuery {
  struct Filter {
    enum SearchDirection { case forward, backward }

    static var defaultLimit: Int { 15 }

    let cursor: Cursor?
    let limit: Int
    let direction: SearchDirection

    private init(_ cursor: Cursor?, _ limit: Int, direction: SearchDirection) {
      self.cursor = cursor
      self.limit = limit
      self.direction = direction
    }

    static func before(_ cursor: Cursor?, limit: Int = Self.defaultLimit) -> Self {
      return .init(cursor, limit, direction: .backward)
    }

    static func after(_ cursor: Cursor?, limit: Int = Self.defaultLimit) -> Self {
      return .init(cursor, limit, direction: .forward)
    }
  }
}
