package hello.dao;

import hello.model.Province;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.support.JdbcDaoSupport;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@Repository
public class ProvinceDAO extends JdbcDaoSupport {
    @Autowired
    public ProvinceDAO(DataSource dataSource) {
        this.setDataSource(dataSource);
    }

    public List<Province> getAllProvinces() {
        String sql = "SELECT id, _name FROM province";
        return getJdbcTemplate().query(sql, new ProvinceDAO.ProvinceMapper());
    }

    private static class ProvinceMapper implements RowMapper<Province> {
        @Override
        public Province mapRow(ResultSet rs, int rowNum) throws SQLException {
            Province p = new Province();
            p.setId(rs.getInt("id"));
            p.setName(rs.getString("_name"));
            return p;
        }
    }

//    public static void main(String[] args) {
//		org.springframework.jdbc.datasource.DriverManagerDataSource ds = new org.springframework.jdbc.datasource.DriverManagerDataSource();
//		ds.setDriverClassName("com.mysql.jdbc.Driver");
//	    ds.setUrl("jdbc:mysql://localhost:3306/guesthouse");
//	    ds.setUsername("root");
//	    ds.setPassword("5555");
//
//	    List<Province> provinceList = new ProvinceDAO(ds).getAllProvinces();
//	    for (Province p : provinceList) {
//            System.out.println(p);
//        }
//	}
}
