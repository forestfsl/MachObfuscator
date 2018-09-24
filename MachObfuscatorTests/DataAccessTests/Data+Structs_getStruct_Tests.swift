import XCTest

class Data_Structs_getStruct_Tests: XCTestCase {

    private struct Sample {
        var b1: UInt16
        var b2: UInt16
    }

    func test_shouldReadSampleStruct() {
        // Given
        let data = Data(bytes: [ 0x01, 0xab, 0xcd, 0xef, 0x02, 0x03  ])

        // When
        let sample: Sample = data.getStruct(atOffset: 1)

        // Then
        XCTAssertEqual(sample.b1, 0xcdab)
        XCTAssertEqual(sample.b2, 0x02ef)
    }
}
