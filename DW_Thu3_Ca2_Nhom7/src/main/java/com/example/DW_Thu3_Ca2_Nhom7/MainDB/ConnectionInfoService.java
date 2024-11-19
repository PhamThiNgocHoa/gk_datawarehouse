package com.example.DW_Thu3_Ca2_Nhom7.MainDB;

import java.util.Map;
import java.util.Optional;

import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

@Service
public class ConnectionInfoService {

    private final JdbcTemplate jdbcTemplate;

    public ConnectionInfoService(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public Optional<Map<String, String>> getConnectionInfo(int dbName) {
        String query = "SELECT file_path, username, password FROM file_config WHERE file_id = ?";
        try {
            Map<String, String> result = jdbcTemplate.queryForObject(query, (rs, rowNum) -> Map.of(
                    "url", rs.getString("file_path"),
                    "username", rs.getString("username"),
                    "password", rs.getString("password")
            ), dbName);
            return Optional.ofNullable(result);
        } catch (EmptyResultDataAccessException e) {
            System.out.println("Không tìm thấy bản ghi nào với file_id: " + dbName);
            return Optional.empty();  // Trả về Optional rỗng nếu không tìm thấy kết quả
        }
    }


    
}

