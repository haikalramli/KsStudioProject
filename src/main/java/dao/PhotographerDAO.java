package dao;

import model.Photographer;
import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PhotographerDAO {
    
    /**
     * Login validation for photographer
     */
    public Photographer login(String email, String password) {
        String sql = "SELECT * FROM photographer WHERE pgemail = ? AND pgpass = ? AND pgstatus = 'active'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Get all photographers
     */
    public List<Photographer> getAll() {
        List<Photographer> list = new ArrayList<>();
        String sql = "SELECT * FROM photographer ORDER BY pgcreated DESC";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                list.add(mapResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    /**
     * Get photographer by ID
     */
    public Photographer getById(int pgId) {
        String sql = "SELECT * FROM photographer WHERE pgid = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, pgId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Create new photographer
     */
    public boolean create(Photographer pg) {
        String sql = "INSERT INTO photographer (pgsnr, pgname, pgph, pgemail, pgpass, pgrole, pgstatus) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            if (pg.getPgSnr() != null) {
                ps.setInt(1, pg.getPgSnr());
            } else {
                ps.setNull(1, Types.INTEGER);
            }
            ps.setString(2, pg.getPgName());
            ps.setString(3, pg.getPgPh());
            ps.setString(4, pg.getPgEmail());
            ps.setString(5, pg.getPgPass());
            ps.setString(6, pg.getPgRole() != null ? pg.getPgRole() : "junior");
            ps.setString(7, pg.getPgStatus() != null ? pg.getPgStatus() : "active");
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Update photographer
     */
    public boolean update(Photographer pg) {
        String sql = "UPDATE photographer SET pgname = ?, pgph = ?, pgemail = ?, pgrole = ?, pgstatus = ? WHERE pgid = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, pg.getPgName());
            ps.setString(2, pg.getPgPh());
            ps.setString(3, pg.getPgEmail());
            ps.setString(4, pg.getPgRole());
            ps.setString(5, pg.getPgStatus());
            ps.setInt(6, pg.getPgId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Delete (soft delete) photographer
     */
    public boolean delete(int pgId) {
        String sql = "UPDATE photographer SET pgstatus = 'inactive' WHERE pgid = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, pgId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Check if email exists
     */
    public boolean emailExists(String email) {
        String sql = "SELECT COUNT(*) FROM photographer WHERE pgemail = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Get count by role
     */
    public int getCountByRole(String role) {
        String sql = "SELECT COUNT(*) FROM photographer WHERE pgrole = ? AND pgstatus = 'active'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, role);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    /**
     * Update password
     */
    public boolean updatePassword(int pgId, String newPassword) {
        String sql = "UPDATE photographer SET pgpass = ? WHERE pgid = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, newPassword);
            ps.setInt(2, pgId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    private Photographer mapResultSet(ResultSet rs) throws SQLException {
        Photographer pg = new Photographer();
        pg.setPgId(rs.getInt("pgid"));
        int snr = rs.getInt("pgsnr");
        pg.setPgSnr(rs.wasNull() ? null : snr);
        pg.setPgName(rs.getString("pgname"));
        pg.setPgPh(rs.getString("pgph"));
        pg.setPgEmail(rs.getString("pgemail"));
        pg.setPgPass(rs.getString("pgpass"));
        pg.setPgRole(rs.getString("pgrole"));
        pg.setPgStatus(rs.getString("pgstatus"));
        pg.setPgCreated(rs.getDate("pgcreated"));
        return pg;
    }
}
