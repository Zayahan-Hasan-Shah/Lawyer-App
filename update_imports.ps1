$files = Get-ChildItem -Path "lib" -Filter "*.dart" -Recurse

foreach ($file in $files) {
    $original = Get-Content $file.FullName -Raw
    $content = $original

    # App & Core & Shared
    $content = $content -replace 'package:lawyer_app/src/app/', 'package:lawyer_app/app/'
    $content = $content -replace 'package:lawyer_app/src/routing/', 'package:lawyer_app/app/router/'
    $content = $content -replace 'package:lawyer_app/src/core/', 'package:lawyer_app/core/'
    $content = $content -replace 'package:lawyer_app/src/widgets/common_widgets/', 'package:lawyer_app/shared/widgets/'
    $content = $content -replace 'package:lawyer_app/src/services/', 'package:lawyer_app/services/'

    # Auth Feature
    $content = $content -replace 'package:lawyer_app/src/models/auth_model/', 'package:lawyer_app/features/auth/data/models/'
    $content = $content -replace 'package:lawyer_app/src/models/user_model/', 'package:lawyer_app/features/auth/data/models/'
    $content = $content -replace 'package:lawyer_app/src/controllers/client_controller/auth_controller/', 'package:lawyer_app/features/auth/presentation/controllers/'
    $content = $content -replace 'package:lawyer_app/src/providers/client_provider/auth_provider/', 'package:lawyer_app/features/auth/presentation/providers/'
    $content = $content -replace 'package:lawyer_app/src/states/client_states/auth_states/', 'package:lawyer_app/features/auth/presentation/states/'
    $content = $content -replace 'package:lawyer_app/src/views/auth/', 'package:lawyer_app/features/auth/presentation/screens/'

    # Client Feature
    $content = $content -replace 'package:lawyer_app/src/models/client_model/', 'package:lawyer_app/features/client/data/models/'
    $content = $content -replace 'package:lawyer_app/src/models/bottom_navigation_model/', 'package:lawyer_app/features/client/data/models/'
    $content = $content -replace 'package:lawyer_app/src/models/subscriber_model/', 'package:lawyer_app/features/client/data/models/'
    $content = $content -replace 'package:lawyer_app/src/controllers/client_controller/bottom_navigation_controller/', 'package:lawyer_app/features/client/presentation/controllers/'
    $content = $content -replace 'package:lawyer_app/src/controllers/client_controller/cases_controller/', 'package:lawyer_app/features/client/presentation/controllers/'
    $content = $content -replace 'package:lawyer_app/src/controllers/client_controller/categories_controller/', 'package:lawyer_app/features/client/presentation/controllers/'
    $content = $content -replace 'package:lawyer_app/src/controllers/client_controller/new_case_controller/', 'package:lawyer_app/features/client/presentation/controllers/'
    $content = $content -replace 'package:lawyer_app/src/controllers/chat_controller/', 'package:lawyer_app/features/client/presentation/controllers/'
    $content = $content -replace 'package:lawyer_app/src/providers/client_provider/bottom_navigation_provider/', 'package:lawyer_app/features/client/presentation/providers/'
    $content = $content -replace 'package:lawyer_app/src/providers/client_provider/case_category_provider/', 'package:lawyer_app/features/client/presentation/providers/'
    $content = $content -replace 'package:lawyer_app/src/providers/client_provider/client_cases_provider/', 'package:lawyer_app/features/client/presentation/providers/'
    $content = $content -replace 'package:lawyer_app/src/providers/client_provider/home_screen_provider/', 'package:lawyer_app/features/client/presentation/providers/'
    $content = $content -replace 'package:lawyer_app/src/providers/client_provider/new_case_provider/', 'package:lawyer_app/features/client/presentation/providers/'
    $content = $content -replace 'package:lawyer_app/src/providers/chat_provider/', 'package:lawyer_app/features/client/presentation/providers/'
    $content = $content -replace 'package:lawyer_app/src/states/client_states/case_states/', 'package:lawyer_app/features/client/presentation/states/'
    $content = $content -replace 'package:lawyer_app/src/states/client_states/category_state/', 'package:lawyer_app/features/client/presentation/states/'
    $content = $content -replace 'package:lawyer_app/src/states/client_states/new_case_state/', 'package:lawyer_app/features/client/presentation/states/'
    $content = $content -replace 'package:lawyer_app/src/states/chat_states/', 'package:lawyer_app/features/client/presentation/states/'
    $content = $content -replace 'package:lawyer_app/src/views/client/bottom_navigation/screens/chat/', 'package:lawyer_app/features/client/presentation/screens/chat/'
    $content = $content -replace 'package:lawyer_app/src/views/client/bottom_navigation/screens/home/', 'package:lawyer_app/features/client/presentation/screens/home/'
    $content = $content -replace 'package:lawyer_app/src/views/client/bottom_navigation/screens/notifications/', 'package:lawyer_app/features/client/presentation/screens/notifications/'
    $content = $content -replace 'package:lawyer_app/src/views/client/bottom_navigation/screens/search/', 'package:lawyer_app/features/client/presentation/screens/search/'
    $content = $content -replace 'package:lawyer_app/src/views/client/bottom_navigation/screens/video/', 'package:lawyer_app/features/client/presentation/screens/video/'
    $content = $content -replace 'package:lawyer_app/src/views/client/bottom_navigation/bottom_navigation_screen.dart', 'package:lawyer_app/features/client/presentation/screens/bottom_navigation_screen.dart'
    $content = $content -replace 'package:lawyer_app/src/widgets/home_widgets/', 'package:lawyer_app/features/client/presentation/widgets/'
    $content = $content -replace 'package:lawyer_app/src/widgets/search_screen_widget/', 'package:lawyer_app/features/client/presentation/widgets/'

    # Lawyer Feature
    $content = $content -replace 'package:lawyer_app/src/models/lawyer_model/', 'package:lawyer_app/features/lawyer/data/models/'
    $content = $content -replace 'package:lawyer_app/src/controllers/lawyer_controller/', 'package:lawyer_app/features/lawyer/presentation/controllers/'
    $content = $content -replace 'package:lawyer_app/src/controllers/client_controller/lawyer_controller/', 'package:lawyer_app/features/lawyer/presentation/controllers/'
    $content = $content -replace 'package:lawyer_app/src/providers/lawyer_provider/', 'package:lawyer_app/features/lawyer/presentation/providers/'
    $content = $content -replace 'package:lawyer_app/src/providers/client_provider/lawyer_provider/', 'package:lawyer_app/features/lawyer/presentation/providers/'
    $content = $content -replace 'package:lawyer_app/src/states/lawyer_states/', 'package:lawyer_app/features/lawyer/presentation/states/'
    $content = $content -replace 'package:lawyer_app/src/states/client_states/lawyer_states/', 'package:lawyer_app/features/lawyer/presentation/states/'
    $content = $content -replace 'package:lawyer_app/src/views/lawyer/auth/', 'package:lawyer_app/features/lawyer/presentation/screens/'
    $content = $content -replace 'package:lawyer_app/src/views/lawyer/lawyer_bottom_navigation/screens/', 'package:lawyer_app/features/lawyer/presentation/screens/'
    $content = $content -replace 'package:lawyer_app/src/views/lawyer/lawyer_bottom_navigation/lawyer_bottom_navigation_screen.dart', 'package:lawyer_app/features/lawyer/presentation/screens/lawyer_bottom_navigation_screen.dart'
    $content = $content -replace 'package:lawyer_app/src/widgets/lawyer_widgets/', 'package:lawyer_app/features/lawyer/presentation/widgets/'

    # Student Feature
    $content = $content -replace 'package:lawyer_app/src/models/student_model/', 'package:lawyer_app/features/student/data/models/'
    $content = $content -replace 'package:lawyer_app/src/controllers/student_controller/', 'package:lawyer_app/features/student/presentation/controllers/'
    $content = $content -replace 'package:lawyer_app/src/providers/student_provider/', 'package:lawyer_app/features/student/presentation/providers/'
    $content = $content -replace 'package:lawyer_app/src/states/student_states/', 'package:lawyer_app/features/student/presentation/states/'
    $content = $content -replace 'package:lawyer_app/src/views/student/auth/', 'package:lawyer_app/features/student/presentation/screens/'
    $content = $content -replace 'package:lawyer_app/src/views/student/bottom_navigation/screens/certification_screens/', 'package:lawyer_app/features/student/presentation/screens/certification_screens/'
    $content = $content -replace 'package:lawyer_app/src/views/student/bottom_navigation/screens/internship_screens/', 'package:lawyer_app/features/student/presentation/screens/internship_screens/'
    $content = $content -replace 'package:lawyer_app/src/views/student/bottom_navigation/screens/', 'package:lawyer_app/features/student/presentation/screens/'
    $content = $content -replace 'package:lawyer_app/src/views/student/bottom_navigation/student_bottom_navigation_screen.dart', 'package:lawyer_app/features/student/presentation/screens/student_bottom_navigation_screen.dart'
    $content = $content -replace 'package:lawyer_app/src/widgets/student_widgets/', 'package:lawyer_app/features/student/presentation/widgets/'

    # Onboarding Feature
    $content = $content -replace 'package:lawyer_app/src/views/on_boarding/', 'package:lawyer_app/features/onboarding/presentation/screens/'
    $content = $content -replace 'package:lawyer_app/src/widgets/on_boarding_widget/', 'package:lawyer_app/features/onboarding/presentation/widgets/'
    $content = $content -replace 'package:lawyer_app/src/widgets/incoming_user_widgets/', 'package:lawyer_app/features/onboarding/presentation/widgets/'
    $content = $content -replace 'package:lawyer_app/src/core/utils/incoming_user_data/', 'package:lawyer_app/core/mock_data/'

    # Profile Feature
    $content = $content -replace 'package:lawyer_app/src/views/profile/', 'package:lawyer_app/features/profile/presentation/screens/'

    # Generic
    $content = $content -replace 'package:lawyer_app/src/', 'package:lawyer_app/'

    if ($original -cne $content) {
        Set-Content -Path $file.FullName -Value $content -Encoding UTF8
    }
}

Write-Host "Imports updated."
