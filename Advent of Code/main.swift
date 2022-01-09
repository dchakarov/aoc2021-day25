//
//  main.swift
//  No rights reserved.
//

import Foundation
import RegexHelper

struct Change {
    let x: Int
    let y: Int
    let c: Character
}

func main() {
    let fileUrl = URL(fileURLWithPath: "./aoc-input")
    guard let inputString = try? String(contentsOf: fileUrl, encoding: .utf8) else { fatalError("Invalid input") }
    
    let lines = inputString.components(separatedBy: "\n")
        .filter { !$0.isEmpty }

    var rows = lines
        .map { Array($0) }

    prettyPrint(rows)
    var changesCount = 0
    var step = 1

    repeat {
        let eastResult = stepEast(rows: rows)
        rows = eastResult.rows
        changesCount = eastResult.changesCount
        let southResult = stepSouth(rows: rows)
        rows = southResult.rows
        changesCount += southResult.changesCount
        print("after step \(step)")
        print("changes: \(changesCount)")
        prettyPrint(rows)
        step += 1
    } while changesCount > 0
}

func stepEast(rows: [[Character]]) -> (rows: [[Character]], changesCount: Int) {
    var changes = [Change]()
    var newRows = rows

    for i in 0 ..< rows.count {
        for j in 0 ..< rows[0].count {
            if rows[i][j] == ">" {
                let pos = adjacent(to: (row: i, col: j), in: rows)
                if rows[pos.row][pos.col] == "." {
                    changes.append(Change(x: i, y: j, c: Character(".")))
                    changes.append(Change(x: pos.row, y: pos.col, c: Character(">")))
                }
            }
        }
    }
    if !changes.isEmpty {
        newRows = apply(changes, to: rows)
    }

    return (rows: newRows, changesCount: changes.count)
}

func stepSouth(rows: [[Character]]) -> (rows: [[Character]], changesCount: Int) {
    var changes = [Change]()
    var newRows = rows

    for i in 0 ..< rows.count {
        for j in 0 ..< rows[0].count {
            if rows[i][j] == "v" {
                let pos = adjacent(to: (row: i, col: j), in: rows)
                if rows[pos.row][pos.col] == "." {
                    changes.append(Change(x: i, y: j, c: Character(".")))
                    changes.append(Change(x: pos.row, y: pos.col, c: Character("v")))
                }
            }
        }
    }
    if !changes.isEmpty {
        newRows = apply(changes, to: rows)
    }

    return (rows: newRows, changesCount: changes.count)
}


func apply(_ changes: [Change], to rows: [[Character]]) -> [[Character]] {
    var result = rows
    changes.forEach { change in
        result[change.x][change.y] = change.c
    }
    return result
}

func adjacent(to pos: (row: Int, col: Int), in rows: [[Character]]) -> (row: Int, col: Int) {
    if rows[pos.row][pos.col] == ">" {
        let c = pos.col >= rows[0].count - 1 ? 0 : pos.col + 1
        return (pos.row, c)
    } else if rows[pos.row][pos.col] == "v" {
        let r = pos.row >= rows.count - 1 ? 0 : pos.row + 1
        return (r, pos.col)
    }
    return pos
}

func prettyPrint(_ rows: [[Character]]) {
    rows.forEach { row in
        print(row.map { String($0) }.joined(separator: ""))
    }
    print("")
}

main()
