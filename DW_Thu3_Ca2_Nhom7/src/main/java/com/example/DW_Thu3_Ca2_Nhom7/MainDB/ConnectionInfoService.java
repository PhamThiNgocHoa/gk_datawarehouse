package com.example.DW_Thu3_Ca2_Nhom7.MainDB;

import java.util.Map;
import java.util.Optional;

import org.jdbi.v3.core.Jdbi;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

@Service
public class ConnectionInfoService {

    private final JdbcTemplate jdbcTemplate;

    public ConnectionInfoService(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public Optional<Map<String, String>> getConnectionInfo(int dbName, String database) {
        // Đảm bảo tên cột được an toàn bằng cách kiểm tra
//        if (!isValidColumnName(database)) {
//            throw new IllegalArgumentException("Tên cột không hợp lệ: " + database);
//        }

        // Tạo truy vấn động với tên cột
        String query = "SELECT " + "file_path" + ", username, password FROM file_config WHERE file_id = ?";
        try {
            Map<String, String> result = jdbcTemplate.queryForObject(query, (rs, rowNum) -> Map.of(
                    "url", rs.getString("file_path"),
                    "username", rs.getString("username"),
                    "password", rs.getString("password")
            ), dbName);
            return Optional.ofNullable(result);
        } catch (EmptyResultDataAccessException e) {
            System.out.println("Không tìm thấy bản ghi nào với file_id: " + dbName);
            return Optional.empty(); // Trả về Optional rỗng nếu không tìm thấy kết quả
        }
    }

    // Hàm kiểm tra tên cột hợp lệ
    private boolean isValidColumnName(String columnName) {
        // Chỉ cho phép các ký tự chữ, số, và gạch dưới
        return columnName != null && columnName.matches("[a-zA-Z0-9_]+");
    }



    public Jdbi createConnection(int file_id, String database, DynamicJdbiFactory jdbiFactory) {

        Optional<Map<String, String>> connectionInfoOpt = getConnectionInfo(file_id, database);


        if (connectionInfoOpt.isEmpty()) {
            throw new RuntimeException("Không thể tìm thấy thông tin kết nối cho dbName: " + database);
        }

       
        Map<String, String> connectionInfo = connectionInfoOpt.get();
        System.out.println(connectionInfo);

        return jdbiFactory.createJdbi(
                connectionInfo.get("url"),
                connectionInfo.get("username"),
                connectionInfo.get("password")
        );
    }

}

