package hello.dao;

import hello.model.District;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.support.JdbcDaoSupport;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@Repository
public class DistrictDAO extends JdbcDaoSupport {
    @Autowired
    public DistrictDAO(DataSource dataSource) {
        this.setDataSource(dataSource);
    }

    public List<District> getDistricts(int province_id) {
        String sql = "SELECT id, _province_id, _name, _prefix FROM district WHERE _province_id = ?";
        return getJdbcTemplate().query(sql, new Object[] { province_id }, new DistrictDAO.DistrictMapper());
    }

    public String getDistrictName(int id) {
        String sql = "SELECT _name FROM district WHERE id = ?";
        return getJdbcTemplate().queryForObject(sql, new Object[] {id}, String.class);
    }

    private static class DistrictMapper implements RowMapper<District> {
        @Override
        public District mapRow(ResultSet rs, int rowNum) throws SQLException {
            District d = new District();
            d.setId(rs.getInt("id"));
            d.setProvinceId(rs.getInt("_province_id"));
            d.setName(rs.getString("_name"));
            d.setPrefix(rs.getString("_prefix"));
            return d;
        }
    }

}
