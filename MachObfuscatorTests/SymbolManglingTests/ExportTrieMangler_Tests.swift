import XCTest

class ExportTrieMangler_Tests: XCTestCase {

    var sut: ExportTrieMangler!

    var rootTrie: Trie!

    override func setUp() {
        sut = ExportTrieMangler()
        var childrenLayer0 = trieChildren(number: 3)
        var childrenLayer1 = trieChildren(number: 2)
        var childrenLayer2 = trieChildren(number: 2)
        let childrenLayer3 = trieChildren(number: 2)

        childrenLayer2 = assignChildren(childrenLayer3, to: childrenLayer2)
        childrenLayer1 = assignChildren(childrenLayer2, to: childrenLayer1)
        childrenLayer0 = assignChildren(childrenLayer1, to: childrenLayer0)

        rootTrie = Trie(exportsSymbol: false,
                            labelRange: 0..<UInt64(2),
                            label: randomLabels(count: 2),
                            children: childrenLayer0)
    }

    override func tearDown() {
        sut = nil
        rootTrie = nil
    }

    func test_exportTrieObfuscation() {
        let obfusctedTrie = sut.mangle(trie: rootTrie, with: 0)
        XCTAssertEqual(obfusctedTrie.label, [0, 0])
        XCTAssertEqual(obfusctedTrie.children[0].label, [1, 1, 1])
        XCTAssertEqual(obfusctedTrie.children[0].children[1].label, [2, 2])
        XCTAssertEqual(obfusctedTrie.children[1].label, [2, 2, 2])
        XCTAssertEqual(obfusctedTrie.children[2].label, [3, 3, 3])
        XCTAssertEqual(obfusctedTrie.children[2].children[0].label, [1, 1])
        XCTAssertEqual(obfusctedTrie.children[2].children[1].label, [2, 2])
    }

    private func trieChildren(number: Int) -> [Trie] {
        var children = [Trie]()
        for index in 1...number {
            let child = Trie(exportsSymbol: index % 2 == 0,
                             labelRange: 0..<UInt64(number),
                             label: randomLabels(count: number),
                             children: [])

            children.append(child)
        }

        return children
    }

    private func randomLabels(count: Int) -> [UInt8] {
        var labels = [UInt8]()
        for _ in 0..<count {
            labels.append(UInt8.random(in: 0...255))
        }

        return labels
    }

    private func assignChildren(_ children: [Trie], to parent: [Trie]) -> [Trie] {
        return parent.map { (trie) in
            var copy = trie
            copy.children = children
            return copy
        }
    }
}
