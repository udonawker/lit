メッセージ表示

    message(STATUS "message : ${XXX}")

スタティックリンクディレクトリパス設定<br/>

    link_directories(${XXX})

変数設定

    set(EXECUTABLE "executable")

サブディレクトリ追加

    add_subdirectory(${XXX} ${CMAKE_CURRENT_BINARY_DIR}/xxx)

ライブラリリンク

    target_link_libraries(${EXECUTABLE}
        pthread
        rt
    )

インクルードディレクトリ

    target_include_directories(${EXECUTABLE}
    PUBLIC
        ${XXX}
    PRIVATE
        ${YYY}
        ${ZZZ}
    )
