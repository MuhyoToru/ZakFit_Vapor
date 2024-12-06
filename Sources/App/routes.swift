import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }

    try app.register(collection: ActivityTypeController())
    try app.register(collection: AlimentController())
    try app.register(collection: AlimentQuantityController())
    try app.register(collection: CaloriesGoalController())
    try app.register(collection: ChosenPeriodController())
    try app.register(collection: FoodPreferenceController())
    try app.register(collection: GenderController())
    try app.register(collection: IntensityController())
    try app.register(collection: MealController())
    try app.register(collection: MealTypeController())
    try app.register(collection: NotificationController())
    try app.register(collection: NotificationTypeController())
    try app.register(collection: PhysicalActivityGoalController())
    try app.register(collection: PhysicalActivityController())
    try app.register(collection: UserController())
    try app.register(collection: UserWeightController())
    try app.register(collection: WeightGoalController())
}
