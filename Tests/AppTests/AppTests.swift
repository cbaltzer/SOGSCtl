@testable import App
import XCTVapor
import XCTest

final class AppTests: XCTestCase {
    func testRoomParser() throws {
        let parser = OutputParser()
        
        
        let sample = """
2022-08-15 14:25:23,278 sc-core config[36303] INFO Loading config from /etc/sogs/sogs.ini

99bf5d
======
Name: session.codes
Description: Public discussion channel for the session.codes service
URL: http://core.session.codes/99bf5d?public_key=c7fbfa183b601f4d393a43644dae11e5f644db2a18c747865db1ca922e632e32
Messages: 0 (0.0 MB)
Attachments: 0 (0.0 MB)
Active users: 0 (1d), 0 (7d), 0 (14d), 0 (30d)
Moderators: 1 admins (0 hidden), 0 moderators (0 hidden):
    - 05a95e35631b2980bf7768597d48e863f40f5851d3c4461f825b701f1d5b97e347 (admin)

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
        XCTAssertEqual(rooms.count, 2)
        
        XCTAssertEqual(rooms[0].token, "99bf5d")
        XCTAssertEqual(rooms[0].name, "session.codes")
        
        
        
        XCTAssertEqual(rooms[1].token, "sc")
        XCTAssertEqual(rooms[1].name, "Session.codes")
        XCTAssertEqual(rooms[1].description, "Session.codes community discussion")
        XCTAssertEqual(rooms[1].url, "http://core.session.codes/sc?public_key=c7fbfa183b601f4d393a43644dae11e5f644db2a18c747865db1ca922e632e32")
        XCTAssertEqual(rooms[1].moderators?.first, "05a95e35631b2980bf7768597d48e863f40f5851d3c4461f825b701f1d5b97e347")
        XCTAssertEqual(rooms[1].activeUsers, "1 (1d), 1 (7d), 1 (14d), 1 (30d)")
        XCTAssertEqual(rooms[1].messages, 1)
    }
}
