package com.example.DW_Thu3_Ca2_Nhom7.Config;

import javax.sql.DataSource;

import org.jdbi.v3.core.Jdbi;
import org.jdbi.v3.sqlobject.SqlObjectPlugin;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.example.DW_Thu3_Ca2_Nhom7.Repository.ExtractDBInterface;

@Configuration
public class JdbiConfig {

    @Bean
    public Jdbi jdbi(DataSource dataSource) {
        // Tạo Jdbi instance và đăng ký SqlObjectPlugin
        return Jdbi.create(dataSource).installPlugin(new SqlObjectPlugin());
    }
    
    @Bean
    public ExtractDBInterface extractDBInterface(Jdbi jdbi) {
        return jdbi.onDemand(ExtractDBInterface.class);  // Đăng ký ExtractDBInterface với JDBI
    }
}