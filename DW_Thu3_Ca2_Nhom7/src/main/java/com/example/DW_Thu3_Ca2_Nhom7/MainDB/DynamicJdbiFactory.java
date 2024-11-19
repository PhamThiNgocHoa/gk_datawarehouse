package com.example.DW_Thu3_Ca2_Nhom7.MainDB;

import javax.sql.DataSource;

import org.jdbi.v3.core.Jdbi;
import org.springframework.stereotype.Component;
import org.apache.commons.dbcp2.BasicDataSource;
@Component
public class DynamicJdbiFactory {

    public Jdbi createJdbi(String url, String username, String password) {
        DataSource dataSource = createDataSource(url, username, password);
        return Jdbi.create(dataSource);
    }

    private DataSource createDataSource(String url, String username, String password) {
        BasicDataSource dataSource = new BasicDataSource();
        dataSource.setUrl(url);
        dataSource.setUsername(username);
        dataSource.setPassword(password);
        return dataSource;
    }
}