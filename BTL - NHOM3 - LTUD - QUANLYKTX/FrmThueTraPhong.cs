using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace quanLyktx
{
    public partial class FrmThueTraPhong : Form
    {
        Ketnoi kn = new Ketnoi();
        public FrmThueTraPhong()
        {
            InitializeComponent();

        }

        private void FrmThueTraPhong_Load(object sender, EventArgs e)
        {
            gdvPhongchothue.DataSource = kn.Lay_DulieuBang("SELECT * FROM vw_DanhSachThueTraPhong");

            
            cboMaPhong.DataSource = kn.Lay_DulieuBang("SELECT ma_phong FROM vw_DanhSachPhongMa");
            cboMaPhong.DisplayMember = "ma_phong";

            
            cboSoPhong.DataSource = kn.Lay_DulieuBang("SELECT so_phong FROM vw_DanhSachSoPhong");
            cboSoPhong.DisplayMember = "so_phong";


        }
        
        private void btnTaoMoi_Click(object sender, EventArgs e)
        {
            string maPhong = cboMaPhong.Text;
            string soPhong = cboSoPhong.Text;
            string khoangThoiGian = txtThoigianthue.Text;
            string tinhTuNgay = datetimeChoThue.Value.ToString("yyyy-MM-dd");
            string maSV = txtMaSV.Text;
            string gioiTinh = cboGioiTinh.Text;

            string sql = $"EXEC sp_ThemThuePhong '{maPhong}', '{soPhong}', N'{khoangThoiGian}', '{tinhTuNgay}', '{maSV}', N'{gioiTinh}'";
            kn.Thucthi(sql);

            MessageBox.Show("Thêm mới thành công!");
            gdvPhongchothue.DataSource = kn.Lay_DulieuBang("SELECT * FROM vw_DanhSachThueTraPhong");
        }

        private void btnXoa_Click(object sender, EventArgs e)
        {
            string maPhong = cboMaPhong.Text;
            string maSV = txtMaSV.Text;

            DialogResult result = MessageBox.Show("Bạn có chắc chắn muốn xóa không?", "Xác nhận", MessageBoxButtons.YesNo);
            if (result == DialogResult.Yes)
            {
                string sql = $"EXEC sp_XoaThuePhong '{maPhong}', '{maSV}'";
                kn.Thucthi(sql);

                MessageBox.Show("Xóa thành công!");
                gdvPhongchothue.DataSource = kn.Lay_DulieuBang("SELECT * FROM vw_DanhSachThueTraPhong");
            }
        }

        private void btnChinh_Click(object sender, EventArgs e)
        {
            string maPhong = cboMaPhong.Text;
            string soPhong = cboSoPhong.Text;
            string khoangThoiGian = txtThoigianthue.Text;
            string tinhTuNgay = datetimeChoThue.Value.ToString("yyyy-MM-dd");
            string maSV = txtMaSV.Text;
            string gioiTinh = cboGioiTinh.Text;

            string sql = $"EXEC sp_CapNhatThuePhong '{maPhong}', '{soPhong}', N'{khoangThoiGian}', '{tinhTuNgay}', '{maSV}', N'{gioiTinh}'";
            kn.Thucthi(sql);

            MessageBox.Show("Cập nhật thành công!");
            gdvPhongchothue.DataSource = kn.Lay_DulieuBang("SELECT * FROM vw_DanhSachThueTraPhong");
        }


        private void btnTimKiem_Click(object sender, EventArgs e)
        {
            string sql = "";

            if (rdoMaPhong.Checked)
            {
                string maPhong = txtMaPhong.Text;
                sql = $"EXEC sp_TimKiemThuePhong @ma_phong = '{maPhong}', @so_phong = NULL";
            }
            else if (rdoSoPhong.Checked)
            {
                string soPhong = txtSoPhong.Text;
                sql = $"EXEC sp_TimKiemThuePhong @ma_phong = NULL, @so_phong = '{soPhong}'";
            }

            gdvPhongchothue.DataSource = kn.Lay_DulieuBang(sql);
        }

        private void gdvPhongchothue_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex >= 0)
            {
                DataGridViewRow row = gdvPhongchothue.Rows[e.RowIndex];
                cboMaPhong.SelectedValue = row.Cells["ma_phong"].Value.ToString();
                cboSoPhong.Text = row.Cells["so_phong"].Value.ToString();
                txtThoigianthue.Text = row.Cells["khoang_thoi_gian"].Value.ToString();
                datetimeChoThue.Value = Convert.ToDateTime(row.Cells["tinh_tu_ngay"].Value);
                txtMaSV.Text = row.Cells["ma_sinh_vien"].Value.ToString();
                cboGioiTinh.Text = row.Cells["gioi_tinh"].Value.ToString();
            }
        }

        private void btnTroLai_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void btnThoat_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }
    }
}
