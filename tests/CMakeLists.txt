add_executable(
    ride_replay_tests
    smoke_test.cpp
)

target_link_libraries(
    ride_replay_tests
    GTest::gtest_main
)

include(GoogleTest)

gtest_discover_tests(ride_replay_tests)