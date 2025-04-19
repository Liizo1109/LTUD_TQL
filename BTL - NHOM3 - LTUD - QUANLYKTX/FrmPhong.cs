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
    public partial class FrmPhong : Form
    {
        Ketnoi kn = new Ketnoi();

        public FrmPhong()
        {
            InitializeComponent();
        }

        private void FrmPhong_Load(object sender, EventArgs e)
        {
            LoadData();
            textBox6.TextChanged += textBox6_TextChanged;

        }
        private void LoadData()
        {
            string sql = "EXEC XemDanhSachPhong"; 
            dgvPhong.DataSource = kn.Lay_DulieuBang(sql);
        }

        private void dgvPhong_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            if (e.RowIndex >= 0)
            {
                DataGridViewRow row = dgvPhong.Rows[e.RowIndex];
                txtMaPhong.Text = row.Cells["ma_phong"].Value.ToString();
                txtSoPhong.Text = row.Cells["so_phong"].Value.ToString();
                txtSucChua.Text = row.Cells["suc_chua"].Value.ToString();
                txtSoNguoiHT.Text = row.Cells["so_nguoi_hien_tai"].Value.ToString();
                txtGia.Text = row.Cells["gia"].Value.ToString();
            }
        }

        private void btnTimKiemDichVu_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(textBox6.Text))
            {
                MessageBox.Show("Vui lòng nhập mã phòng để tìm kiếm!", "Thông báo");
                return;
            }

            string sql = $"SELECT * FROM Phong WHERE ma_phong = '{textBox6.Text.Trim()}'";
            DataTable dt = kn.Lay_DulieuBang(sql);

            if (dt.Rows.Count > 0)
            {
                dgvPhong.DataSource = dt;
            }
            else
            {
                MessageBox.Show("Không tìm thấy phòng với mã này.", "Thông báo");
            }
        }

        private void btnChinh_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtMaPhong.Text))
            {
                MessageBox.Show("Vui lòng nhập Mã phòng để chỉnh sửa!", "Thông báo");
                return;
            }

            string sqlUpdate = $"EXEC CapNhatPhong '{txtMaPhong.Text}', '{txtSoPhong.Text}', '{txtSucChua.Text}', '{txtSoNguoiHT.Text}', '{txtGia.Text}'";
            kn.Thucthi(sqlUpdate);
            LoadData();
            MessageBox.Show("Cập nhật thông tin phòng thành công!");
        }

        private void btnXoa_Click(object sender, EventArgs e)
        {
            if (MessageBox.Show("Bạn có chắc muốn xóa phòng này?", "Xác nhận", MessageBoxButtons.YesNo) == DialogResult.Yes)
            {
                string sqlXoa = $"EXEC XoaPhong '{txtMaPhong.Text}'";
                kn.Thucthi(sqlXoa);
                LoadData();
            }
        }

        private void btnTaoMoi_Click(object sender, EventArgs e)
        {

            if (string.IsNullOrWhiteSpace(txtSoPhong.Text) ||
        string.IsNullOrWhiteSpace(txtSucChua.Text) ||
        string.IsNullOrWhiteSpace(txtSoNguoiHT.Text) ||
        string.IsNullOrWhiteSpace(txtGia.Text))
            {
                MessageBox.Show("Vui lòng nhập đầy đủ thông tin!", "Thông báo");
                return;
            }

            string sqlThem = $"EXEC ThemPhong '{txtSoPhong.Text}', '{txtSucChua.Text}', '{txtSoNguoiHT.Text}', '{txtGia.Text}'";
            kn.Thucthi(sqlThem);
            LoadData();
            MessageBox.Show("Đã thêm mới phòng thành công!");

            txtMaPhong.Clear();
            txtSoPhong.Clear();
            txtSucChua.Clear();
            txtSoNguoiHT.Clear();
            txtGia.Clear();

        }

        private void btnTroLai_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void btnThoat_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }

        private void textBox6_TextChanged(object sender, EventArgs e)
        {

            string keyword = textBox6.Text.Trim();

            if (string.IsNullOrEmpty(keyword))
            {
                LoadData();
                return;
            }

            string sql = $@"
                SELECT * FROM Phong 
                WHERE 
                CAST(ma_phong AS NVARCHAR) LIKE N'%{keyword}%' OR 
                so_phong LIKE N'%{keyword}%' OR 
                CAST(suc_chua AS NVARCHAR) LIKE N'%{keyword}%' OR
                CAST(so_nguoi_hien_tai AS NVARCHAR) LIKE N'%{keyword}%' OR
                CAST(gia AS NVARCHAR) LIKE N'%{keyword}%'
                ";

            dgvPhong.DataSource = kn.Lay_DulieuBang(sql);
        }
    }
}
