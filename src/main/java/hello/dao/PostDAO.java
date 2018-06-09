package hello.dao;

import hello.model.Post;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.support.JdbcDaoSupport;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@Repository
public class PostDAO extends JdbcDaoSupport {

    @Autowired
    public PostDAO(DataSource dataSource) {
        this.setDataSource(dataSource);
    }

    public List<Post> getPostsToApprove() {
        String sql = "SELECT * FROM post WHERE approved = 0 ORDER BY time DESC";
        return this.getJdbcTemplate().query(sql, new PostDAO.PostMapper());
    }

    public String approvePost(int postId) {
        String sql = "UPDATE post SET enabled=1, approved=1 WHERE id=" + postId;
        System.out.println("sql = " + sql);
        try {
            getJdbcTemplate().update(sql);
        } catch (Exception e) {
            e.printStackTrace();
            return e.getMessage();
        }
        return "OK";
    }

    public String declinePost(int postId) {
        String sql = "UPDATE post SET enabled=0, approved=1 WHERE id=" + postId;
        try {
            getJdbcTemplate().update(sql);
        } catch (Exception e) {
            e.printStackTrace();
            return e.getMessage();
        }
        return "OK";
    }


    public int countPostsAtHomePage(String city, String district, int lowPrice, int highPrice) {
        String sql = "SELECT count(*) " +
                "FROM post WHERE enabled=1 AND city LIKE '%" + city + "%'";
        if(district != null) sql += " AND district LIKE '%" + district + "%'";

        if(lowPrice != 0 || highPrice != 30000000) {
            sql = sql + " AND price >= " + lowPrice + " AND price <= " + highPrice;
        }

        return this.getJdbcTemplate().queryForObject(sql, Integer.class);
    }

    public List<Post> getPostsAtHomePage(String city, String district, int lowPrice, int highPrice, int start, int nums, String orderBy) {
        String sql = "SELECT id, user_id, name, description, avatar, street, district, city, area, price, time, contact_name, contact_phone, contact_email, contact_address " +
                "FROM post WHERE enabled=1 AND city LIKE '%" + city + "%'";
        if(district != null) sql += " AND district LIKE '%" + district + "%'";

        if(lowPrice != 0 || highPrice != 30000000) {
            sql = sql + " AND price >= " + lowPrice + " AND price <= " + highPrice;
        }

        if(orderBy != null) sql = sql + " ORDER BY " + orderBy;

        sql = sql + " LIMIT " + start + ", " + nums;
        System.out.println("[PostDAO] sql = " + sql);
        return this.getJdbcTemplate().query(sql, new PostDAO.PostHomePageMapper());
    }

    private static class PostHomePageMapper implements RowMapper<Post> {

        @Override
        public Post mapRow(ResultSet rs, int rowNum) throws SQLException {
            Post p = new Post();
            p.setId(rs.getInt("id"));
            p.setUserId(rs.getInt("user_id"));
            p.setName(rs.getString("name"));
            p.setDescription(rs.getString("description"));
            p.setAvatar(rs.getString("avatar"));
            p.setStreet(rs.getString("street"));
            p.setDistrict(rs.getString("district"));
            p.setCity(rs.getString("city"));
            p.setArea(rs.getInt("area"));
            p.setPrice(rs.getInt("price"));
            p.setTime(rs.getTimestamp("time"));
            p.setContactName(rs.getString("contact_name"));
            p.setContactEmail(rs.getString("contact_email"));
            p.setContactAddress(rs.getString("contact_address"));
            p.setContactPhone(rs.getString("contact_phone"));

            return p;
        }
    }

    private static class PostMapper implements RowMapper<Post> {
        @Override
        public Post mapRow(ResultSet rs, int rowNum) throws SQLException {
            Post p = new Post();
            p.setId(rs.getInt("id"));
            p.setUserId(rs.getInt("user_id"));
            p.setName(rs.getString("name"));
            p.setDescription(rs.getString("description"));
            p.setAvatar(rs.getString("avatar"));
            String images = rs.getString("image_urls");
            if(images != null) {
                List<String> imageList = new ArrayList<>();
                if(!images.contains("|")) imageList.add(images);
                else {
                    String []arr = images.split("|");
                    for (int i=0; i<arr.length; i++) {
                        imageList.add(arr[i]);
                    }
                }
                p.setImageUrls(imageList);
            }
            p.setStreet(rs.getString("street"));
            p.setDistrict(rs.getString("district"));
            p.setCity(rs.getString("city"));
            p.setArea(rs.getInt("area"));
            p.setPrice(rs.getInt("price"));
            p.setTime(rs.getTimestamp("time"));
            p.setContactName(rs.getString("contact_name"));
            p.setContactEmail(rs.getString("contact_email"));
            p.setContactAddress(rs.getString("contact_address"));
            p.setContactPhone(rs.getString("contact_phone"));

            return p;
        }
    }
}
