set(COVERAGE_CMAKE "${CMAKE_BINARY_DIR}/cmake/CodeCoverage.cmake")
if(NOT EXISTS ${COVERAGE_CMAKE})
  set(COVERAGE_URL "https://raw.githubusercontent.com/bilke/cmake-modules/master/CodeCoverage.cmake")
  file(DOWNLOAD ${COVERAGE_URL} ${COVERAGE_CMAKE})
  
  # Patch the downloaded CodeCoverage.cmake to handle unsupported compilers gracefully
  file(READ ${COVERAGE_CMAKE} COVERAGE_CONTENT)
  string(REPLACE 
    "    message(FATAL_ERROR \"Compiler is not GNU or Flang! Aborting...\")"
    "    message(WARNING \"Compiler for language ${LANG} is not GNU or Flang!\")"
    COVERAGE_CONTENT
    "${COVERAGE_CONTENT}"
  )
  file(WRITE ${COVERAGE_CMAKE} "${COVERAGE_CONTENT}")
endif()

include(${COVERAGE_CMAKE})

function(setup_coverage TARGET)
  target_compile_options(${TARGET} PRIVATE -g -O0 -fprofile-arcs -ftest-coverage)
  target_link_libraries(${TARGET} PRIVATE gcov)
endfunction()
