@testable import App
import XCTVapor

final class AppTests: XCTestCase {
    func testRoomParser() throws {
        let parser = OutputParser()
        
        
        let sample = """
2022-08-12 17:14:11,214 sc-core config[18918] INFO Loading config from /etc/sogs/sogs.ini

sc
==
Name: Session.codes
Description: Session.codes community discussion
URL: http://core.session.codes/sc?public_key=c7fbfa183b601f4d393a43644dae11e5f644db2a18c747865db1ca922e632e32
Messages: 1 (0.0 MB)
Attachments: 0 (0.0 MB)
Active users: 1 (1d), 1 (7d), 1 (14d), 1 (30d)
Moderators: 0 admins (0 hidden), 1 moderators (0 hidden):
    - 05a95e35631b2980bf7768597d48e863f40f5851d3c4461f825b701f1d5b97e347 (moderator)
"""
        
        let rooms = parser.findRooms(log: sample)
        
        
        XCTAssertEqual(rooms.count, 1)
        XCTAssertEqual(rooms.first?.token, "sc")
        XCTAssertEqual(rooms.first?.name, "Session.codes")
        XCTAssertEqual(rooms.first?.description, "Session.codes community discussion")
        XCTAssertEqual(rooms.first?.url, "http://core.session.codes/sc?public_key=c7fbfa183b601f4d393a43644dae11e5f644db2a18c747865db1ca922e632e32")
        XCTAssertEqual(rooms.first?.moderators?.first, "05a95e35631b2980bf7768597d48e863f40f5851d3c4461f825b701f1d5b97e347")
        XCTAssertEqual(rooms.first?.activeUsers, "1 (1d), 1 (7d), 1 (14d), 1 (30d)")
    }
}
