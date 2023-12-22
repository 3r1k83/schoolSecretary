import XCTest
@testable import SchoolSecretary

class ClassroomManagerTests: XCTestCase {

    // MARK: - Test Helpers
    
    // Mock implementation of SchoolAPIClient
    class MockSchoolAPIClient: SchoolAPIClient {
        override func addClassroom(classroom: Classroom, completion: @escaping (Result<Classroom, Error>) -> Void) {
            // Mock the implementation to simulate a successful response
            completion(.success(classroom))
        }
    }
    
    class FailingMockSchoolAPIClient: SchoolAPIClient {
        override func addClassroom(classroom: Classroom, completion: @escaping (Result<Classroom, Error>) -> Void) {
            // Simulate a failure response with a generic error
            completion(.failure(NSError(domain: "TestErrorDomain", code: 1, userInfo: nil)))
        }
    }

    // MARK: - Tests
    
    func testAddClassroomSuccess() {
        // Arrange
        let classroomManager = ClassroomManager()
        let mockAPIClient = MockSchoolAPIClient()
        classroomManager.networkManager = mockAPIClient
        let classroomToAdd = Classroom(_id: "1", roomName: "Test Room", students: [], professor: nil)

        // Act
        let expectation = XCTestExpectation(description: "Adding classroom")
        classroomManager.addClassroom(classroom: classroomToAdd) { result in
            // Assert
            switch result {
            case .success:
                XCTAssert(true, "Classroom added successfully")
            case .failure(let error):
                XCTFail("Error adding classroom: \(error)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testAddClassroomFailure() {
        // Arrange
        let classroomManager = ClassroomManager()
        classroomManager.networkManager = FailingMockSchoolAPIClient()
        let classroom = Classroom(_id: "1", roomName: "A101", students: [], professor: nil)

        // Act
        let expectation = XCTestExpectation(description: "Add classroom failure")
        classroomManager.addClassroom(classroom: classroom) { result in
            // Assert
            switch result {
            case .success:
                XCTFail("Unexpected success")
            case .failure:
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func testUpdateClassroom(successful: Bool) {
        // Arrange
        let manager = ClassroomManager()
        let classroom = Classroom(_id: "1", roomName: "Room 1", students: [], professor: nil)
        let mockNetworkManager = (successful ? MockSchoolAPIClient() : FailingMockSchoolAPIClient())
        manager.networkManager = mockNetworkManager

        // Act
        let expectation = XCTestExpectation(description: "Update classroom")
        manager.updateClassroom(classroom: classroom) { result in
            // Assert
            switch result {
            case .success(let success):
                XCTAssertEqual(success, successful)
            case .failure:
                XCTAssertFalse(successful, "Expected success, but got failure.")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    // class is not present so it cannot be updated
    func testUpdateClassroomSuccess() {
        testUpdateClassroom(successful: false)
    }

    func testUpdateClassroomFailure() {
        testUpdateClassroom(successful: false)
    }

    func testDeleteClassroom() {
        // Arrange
        let manager = ClassroomManager()
        let classroom = Classroom(_id: "1", roomName: "Room 1", students: [], professor: nil)
        let mockNetworkManager = MockSchoolAPIClient()
        manager.networkManager = mockNetworkManager

        // Act
        let expectation = XCTestExpectation(description: "Delete classroom")
        manager.deleteClassroom(classroom: classroom)

        // Assert
        XCTAssertFalse(manager.classrooms.contains(classroom))
        expectation.fulfill()
        wait(for: [expectation], timeout: 5.0)
    }

    func testSyncWithBackend(successful: Bool) {
        // Arrange
        let manager = ClassroomManager()
        let mockNetworkManager = (successful ? MockSchoolAPIClient() : FailingMockSchoolAPIClient())
        manager.networkManager = mockNetworkManager

        // Act
        let expectation = XCTestExpectation(description: "Sync with backend")
        manager.syncWithBackend { error in
            // Assert
            if successful {
                XCTAssertNil(error)
                XCTAssertTrue(manager.classrooms.count > 0)
            } else {
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func testSyncWithBackendSuccess() {
        testSyncWithBackend(successful: true)
    }

}
