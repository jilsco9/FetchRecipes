//
//  FetchRecipesTests.swift
//  FetchRecipesTests
//
//  Created by Jillian Scott on 9/24/23.
//

import XCTest
@testable import FetchRecipes

// Some sample tests to indicate how I go about testing
final class FetchRecipesTests: XCTestCase {
    
    func testGeneralErrorAlertDetails() {
        let error = GeneralError.unknown(error: URLError(.cancelled))
        let alertDetails = error.alertDetails
        
        XCTAssertEqual(alertDetails.id, "GeneralError.unknown")
        XCTAssertEqual(alertDetails.title, "Error")
        XCTAssertEqual(alertDetails.userDescription, "An error occurred")
        XCTAssertEqual(alertDetails.buttonText, "OK")
        XCTAssertEqual(alertDetails.isRetryable, false)
    }
    
    func testMealDetailsDecodeMismatch() {
        let json = """
    {
        "idMeal": "testID",
        "strMeal": "testMeal",
        "strCategory": "testCategory",
        "strInstructions": "testInstructions",
        "strMeasure1": "matchedMeasure1",
        "strMeasure2": "mismatchedMeasure1",
        "strIngredient1": "matchedIngredient1",
        "strIngredient3": "mismatchedIngredient1"
    }
    """
        
        guard let data = json.data(using: .utf8) else {
            XCTFail("Could not convert test json to data")
            return
        }
        
        var details: MealDetails
        
        do {
            details = try JSONDecoder().decode(MealDetails.self, from: data)
        } catch {
            XCTFail("Error parsing MealDetails data")
            return
        }
        
        XCTAssertEqual(details.measurementsAndIngredients.count, 1)
        XCTAssertEqual(details.measurementsAndIngredients.first!.0, "matchedMeasure1")
        XCTAssertEqual(details.measurementsAndIngredients.first!.1, "matchedIngredient1")
    }
    
    func testMealDetailsDecodeDuplicate() {
        let json = """
    {
        "idMeal": "testID",
        "strMeal": "testMeal",
        "strCategory": "testCategory",
        "strInstructions": "testInstructions",
        "strMeasure1": "duplicateMeasure",
        "strMeasure2": "duplicateMeasure",
        "strIngredient1": "duplicateIngredient",
        "strIngredient3": "duplicateIngredient"
    }
    """
        
        guard let data = json.data(using: .utf8) else {
            XCTFail("Could not convert test json to data")
            return
        }
        
        var details: MealDetails
        
        do {
            details = try JSONDecoder().decode(MealDetails.self, from: data)
        } catch {
            XCTFail("Error parsing MealDetails data")
            return
        }
        
        XCTAssertEqual(details.measurementsAndIngredients.count, 1)
        XCTAssertEqual(details.measurementsAndIngredients.first!.0, "duplicateMeasure")
        XCTAssertEqual(details.measurementsAndIngredients.first!.1, "duplicateIngredient")
    }
}
