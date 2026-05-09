$ErrorActionPreference = "Stop"

# Create new directory structure
$dirs = @(
    "lib/app/router",
    "lib/shared/widgets",
    "lib/features/auth/data/datasources",
    "lib/features/auth/data/models",
    "lib/features/auth/data/repositories",
    "lib/features/auth/domain/entities",
    "lib/features/auth/domain/repositories",
    "lib/features/auth/domain/usecases",
    "lib/features/auth/presentation/controllers",
    "lib/features/auth/presentation/providers",
    "lib/features/auth/presentation/states",
    "lib/features/auth/presentation/screens",
    "lib/features/client/data/datasources",
    "lib/features/client/data/models",
    "lib/features/client/data/repositories",
    "lib/features/client/domain/entities",
    "lib/features/client/domain/repositories",
    "lib/features/client/domain/usecases",
    "lib/features/client/presentation/controllers",
    "lib/features/client/presentation/providers",
    "lib/features/client/presentation/states",
    "lib/features/client/presentation/screens/chat",
    "lib/features/client/presentation/screens/home",
    "lib/features/client/presentation/screens/notifications",
    "lib/features/client/presentation/screens/search",
    "lib/features/client/presentation/screens/video",
    "lib/features/client/presentation/widgets",
    "lib/features/lawyer/data/datasources",
    "lib/features/lawyer/data/models",
    "lib/features/lawyer/data/repositories",
    "lib/features/lawyer/domain/entities",
    "lib/features/lawyer/domain/repositories",
    "lib/features/lawyer/domain/usecases",
    "lib/features/lawyer/presentation/controllers",
    "lib/features/lawyer/presentation/providers",
    "lib/features/lawyer/presentation/states",
    "lib/features/lawyer/presentation/screens",
    "lib/features/lawyer/presentation/widgets",
    "lib/features/student/data/datasources",
    "lib/features/student/data/models",
    "lib/features/student/data/repositories",
    "lib/features/student/domain/entities",
    "lib/features/student/domain/repositories",
    "lib/features/student/domain/usecases",
    "lib/features/student/presentation/controllers",
    "lib/features/student/presentation/providers",
    "lib/features/student/presentation/states",
    "lib/features/student/presentation/screens/certification_screens",
    "lib/features/student/presentation/screens/internship_screens",
    "lib/features/student/presentation/widgets",
    "lib/features/onboarding/presentation/screens",
    "lib/features/onboarding/presentation/widgets",
    "lib/features/profile/presentation/screens",
    "lib/services"
)

foreach ($dir in $dirs) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Force -Path $dir | Out-Null
    }
}

# Helper function to move files securely
function Move-Safe {
    param ($Source, $Dest)
    if (Test-Path $Source) {
        Move-Item -Path $Source -Destination $Dest -Force
    }
}

# 1. Move App and Routing
Move-Safe -Source "lib/src/app/initialize_app.dart" -Dest "lib/app/"
Move-Safe -Source "lib/src/routing/app_router.dart" -Dest "lib/app/router/"
Move-Safe -Source "lib/src/routing/route_names.dart" -Dest "lib/app/router/"

# 2. Move Core (already partially exists, just move the rest of src/core)
Move-Safe -Source "lib/src/core/constants" -Dest "lib/core/"
Move-Safe -Source "lib/src/core/utils" -Dest "lib/core/"
Move-Safe -Source "lib/src/core/validation" -Dest "lib/core/"
Move-Safe -Source "lib/src/core/mock_data" -Dest "lib/core/"

# 3. Move Shared Widgets
Move-Safe -Source "lib/src/widgets/common_widgets/*" -Dest "lib/shared/widgets/"

# 4. Move Auth Feature
Move-Safe -Source "lib/src/models/auth_model/*" -Dest "lib/features/auth/data/models/"
Move-Safe -Source "lib/src/controllers/client_controller/auth_controller/*" -Dest "lib/features/auth/presentation/controllers/"
Move-Safe -Source "lib/src/providers/client_provider/auth_provider/*" -Dest "lib/features/auth/presentation/providers/"
Move-Safe -Source "lib/src/states/client_states/auth_states/*" -Dest "lib/features/auth/presentation/states/"
Move-Safe -Source "lib/src/views/auth/*" -Dest "lib/features/auth/presentation/screens/"

# 5. Move Client Feature
Move-Safe -Source "lib/src/models/client_model/*" -Dest "lib/features/client/data/models/"
Move-Safe -Source "lib/src/controllers/client_controller/bottom_navigation_controller" -Dest "lib/features/client/presentation/controllers/"
Move-Safe -Source "lib/src/controllers/client_controller/cases_controller" -Dest "lib/features/client/presentation/controllers/"
Move-Safe -Source "lib/src/controllers/client_controller/categories_controller" -Dest "lib/features/client/presentation/controllers/"
Move-Safe -Source "lib/src/controllers/client_controller/new_case_controller" -Dest "lib/features/client/presentation/controllers/"
Move-Safe -Source "lib/src/controllers/chat_controller/*" -Dest "lib/features/client/presentation/controllers/"
Move-Safe -Source "lib/src/providers/client_provider/bottom_navigation_provider" -Dest "lib/features/client/presentation/providers/"
Move-Safe -Source "lib/src/providers/client_provider/case_category_provider" -Dest "lib/features/client/presentation/providers/"
Move-Safe -Source "lib/src/providers/client_provider/client_cases_provider" -Dest "lib/features/client/presentation/providers/"
Move-Safe -Source "lib/src/providers/client_provider/home_screen_provider" -Dest "lib/features/client/presentation/providers/"
Move-Safe -Source "lib/src/providers/client_provider/new_case_provider" -Dest "lib/features/client/presentation/providers/"
Move-Safe -Source "lib/src/providers/chat_provider/*" -Dest "lib/features/client/presentation/providers/"
Move-Safe -Source "lib/src/states/client_states/case_states" -Dest "lib/features/client/presentation/states/"
Move-Safe -Source "lib/src/states/client_states/category_state" -Dest "lib/features/client/presentation/states/"
Move-Safe -Source "lib/src/states/client_states/new_case_state" -Dest "lib/features/client/presentation/states/"
Move-Safe -Source "lib/src/states/chat_states/*" -Dest "lib/features/client/presentation/states/"
Move-Safe -Source "lib/src/views/client/bottom_navigation/bottom_navigation_screen.dart" -Dest "lib/features/client/presentation/screens/"
Move-Safe -Source "lib/src/views/client/bottom_navigation/screens/chat/*" -Dest "lib/features/client/presentation/screens/chat/"
Move-Safe -Source "lib/src/views/client/bottom_navigation/screens/home/*" -Dest "lib/features/client/presentation/screens/home/"
Move-Safe -Source "lib/src/views/client/bottom_navigation/screens/notifications/*" -Dest "lib/features/client/presentation/screens/notifications/"
Move-Safe -Source "lib/src/views/client/bottom_navigation/screens/search/*" -Dest "lib/features/client/presentation/screens/search/"
Move-Safe -Source "lib/src/views/client/bottom_navigation/screens/video/*" -Dest "lib/features/client/presentation/screens/video/"
Move-Safe -Source "lib/src/widgets/home_widgets/*" -Dest "lib/features/client/presentation/widgets/"
Move-Safe -Source "lib/src/widgets/search_screen_widget/*" -Dest "lib/features/client/presentation/widgets/"

# 6. Move Lawyer Feature
Move-Safe -Source "lib/src/models/lawyer_model/*" -Dest "lib/features/lawyer/data/models/"
Move-Safe -Source "lib/src/controllers/lawyer_controller/*" -Dest "lib/features/lawyer/presentation/controllers/"
Move-Safe -Source "lib/src/controllers/client_controller/lawyer_controller/*" -Dest "lib/features/lawyer/presentation/controllers/"
Move-Safe -Source "lib/src/providers/lawyer_provider/*" -Dest "lib/features/lawyer/presentation/providers/"
Move-Safe -Source "lib/src/providers/client_provider/lawyer_provider/*" -Dest "lib/features/lawyer/presentation/providers/"
Move-Safe -Source "lib/src/states/lawyer_states/*" -Dest "lib/features/lawyer/presentation/states/"
Move-Safe -Source "lib/src/states/client_states/lawyer_states/*" -Dest "lib/features/lawyer/presentation/states/"
Move-Safe -Source "lib/src/views/lawyer/auth/*" -Dest "lib/features/lawyer/presentation/screens/"
Move-Safe -Source "lib/src/views/lawyer/lawyer_bottom_navigation/lawyer_bottom_navigation_screen.dart" -Dest "lib/features/lawyer/presentation/screens/"
Move-Safe -Source "lib/src/views/lawyer/lawyer_bottom_navigation/screens/*" -Dest "lib/features/lawyer/presentation/screens/"
Move-Safe -Source "lib/src/widgets/lawyer_widgets/*" -Dest "lib/features/lawyer/presentation/widgets/"

# 7. Move Student Feature
Move-Safe -Source "lib/src/models/student_model/*" -Dest "lib/features/student/data/models/"
Move-Safe -Source "lib/src/controllers/student_controller/*" -Dest "lib/features/student/presentation/controllers/"
Move-Safe -Source "lib/src/providers/student_provider/*" -Dest "lib/features/student/presentation/providers/"
Move-Safe -Source "lib/src/states/student_states/*" -Dest "lib/features/student/presentation/states/"
Move-Safe -Source "lib/src/views/student/auth/*" -Dest "lib/features/student/presentation/screens/"
Move-Safe -Source "lib/src/views/student/bottom_navigation/student_bottom_navigation_screen.dart" -Dest "lib/features/student/presentation/screens/"
Move-Safe -Source "lib/src/views/student/bottom_navigation/screens/*.dart" -Dest "lib/features/student/presentation/screens/"
Move-Safe -Source "lib/src/views/student/bottom_navigation/screens/certification_screens/*" -Dest "lib/features/student/presentation/screens/certification_screens/"
Move-Safe -Source "lib/src/views/student/bottom_navigation/screens/internship_screens/*" -Dest "lib/features/student/presentation/screens/internship_screens/"
Move-Safe -Source "lib/src/widgets/student_widgets/*" -Dest "lib/features/student/presentation/widgets/"

# 8. Move Onboarding Feature
Move-Safe -Source "lib/src/views/on_boarding/*" -Dest "lib/features/onboarding/presentation/screens/"
Move-Safe -Source "lib/src/widgets/on_boarding_widget/*" -Dest "lib/features/onboarding/presentation/widgets/"
Move-Safe -Source "lib/src/widgets/incoming_user_widgets/*" -Dest "lib/features/onboarding/presentation/widgets/"

# 9. Move Profile Feature
Move-Safe -Source "lib/src/views/profile/*" -Dest "lib/features/profile/presentation/screens/"

# 10. Services
Move-Safe -Source "lib/src/services/*" -Dest "lib/services/"

# 11. Root models (bottom nav, user, etc)
Move-Safe -Source "lib/src/models/bottom_navigation_model" -Dest "lib/features/client/data/models/"
Move-Safe -Source "lib/src/models/user_model" -Dest "lib/features/auth/data/models/"
Move-Safe -Source "lib/src/models/subscriber_model" -Dest "lib/features/client/data/models/"

# Finally, cleanup empty directories
Write-Host "Cleaning up empty directories..."
Remove-Item -Path "lib/src" -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "Restructure complete."
