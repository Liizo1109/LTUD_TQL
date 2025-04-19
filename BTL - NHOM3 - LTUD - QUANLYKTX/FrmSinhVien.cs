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
    public partial class FrmSinhVien : Form
    {
        Ketnoi kn = new Ketnoi();
        public FrmSinhVien()
        {
            InitializeComponent();
        }

        private void FrmSinhVien_Load(object sender, EventArgs e)
        {
            LoadData();

            cboGioiTinh.Items.Clear();
            cboGioiTinh.Items.Add("Nam");
            cboGioiTinh.Items.Add("Nữ");
            cboGioiTinh.SelectedIndex = 0;
        }
        void LoadData()
        {
            string sql = "SELECT * FROM v_DanhSachSinhVien";
            dgvDichvu.DataSource = kn.Lay_DulieuBang(sql);
        }

        private void dgvDichvu_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {
            int i = e.RowIndex;
            if (i >= 0)
            {
                txtMaSV.Text = dgvDichvu.Rows[i].Cells["ma_sinh_vien"].Value.ToString();
                txtTenSV.Text = dgvDichvu.Rows[i].Cells["ho_ten"].Value.ToString();
                cboGioiTinh.Text = dgvDichvu.Rows[i].Cells["gioi_tinh"].Value.ToString();
                dateTimeNS.Value = Convert.ToDateTime(dgvDichvu.Rows[i].Cells["ngay_sinh"].Value);
                txtSoDT.Text = dgvDichvu.Rows[i].Cells["dien_thoai"].Value.ToString();
                txtEmail.Text = dgvDichvu.Rows[i].Cells["email"].Value.ToString();
            }
        }

        private void btnTaoMoi_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtTenSV.Text) || cboGioiTinh.SelectedIndex == -1 ||
                string.IsNullOrWhiteSpace(txtSoDT.Text) || string.IsNullOrWhiteSpace(txtEmail.Text))
            {
                MessageBox.Show("Vui lòng nhập đầy đủ thông tin!", "Thiếu dữ liệu");
                return;
            }

            try
            {
                string sql = $"EXEC ThemSinhVien N'{txtTenSV.Text}', N'{cboGioiTinh.Text}', " +
                             $"'{dateTimeNS.Value:yyyy-MM-dd}', '{txtSoDT.Text}', '{txtEmail.Text}'";

                kn.Thucthi(sql);
                LoadData();
                MessageBox.Show("Thêm sinh viên thành công!");
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Lỗi khi thêm: {ex.Message}");
            }
        }

        private void btnChinhSua_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtMaSV.Text))
            {
                MessageBox.Show("Vui lòng chọn sinh viên cần sửa!");
                return;
            }

            string sql = $"EXEC CapNhatSinhVien {txtMaSV.Text}, N'{txtTenSV.Text}', N'{cboGioiTinh.Text}', " +
                         $"'{dateTimeNS.Value:yyyy-MM-dd}', '{txtSoDT.Text}', '{txtEmail.Text}'";

            try
            {
                kn.Thucthi(sql);
                LoadData();
                MessageBox.Show("Cập nhật thành công!");
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Lỗi khi cập nhật: {ex.Message}");
            }
        }

        private void btnXoa_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtMaSV.Text))
            {
                MessageBox.Show("Vui lòng chọn sinh viên để xóa.");
                return;
            }

            DialogResult r = MessageBox.Show("Bạn có chắc chắn muốn xóa?", "Xác nhận", MessageBoxButtons.YesNo);
            if (r == DialogResult.Yes)
            {
                try
                {
                    string sql = $"EXEC XoaSinhVien {txtMaSV.Text}";
                    kn.Thucthi(sql);
                    LoadData();
                    MessageBox.Show("Xóa thành công!");
                }
                catch (Exception ex)
                {
                    MessageBox.Show($"Lỗi khi xóa: {ex.Message}");
                }
            }
        }

        private void btnTimKiem_Click(object sender, EventArgs e)
        {
            string sql = "";
            if (rdoMaSV.Checked)
            {
                if (string.IsNullOrWhiteSpace(txtTimKiemMa.Text))
                {
                    MessageBox.Show("Nhập mã sinh viên để tìm!");
                    return;
                }
                sql = $"EXEC TimKiemSinhVien 'ma', '{txtTimKiemMa.Text}'";
            }
            else if (rdoTenSV.Checked)
            {
                if (string.IsNullOrWhiteSpace(txtTimKiemTen.Text))
                {
                    MessageBox.Show("Nhập tên sinh viên để tìm!");
                    return;
                }
                sql = $"EXEC TimKiemSinhVien 'ten', N'{txtTimKiemTen.Text}'";
            }

            dgvDichvu.DataSource = kn.Lay_DulieuBang(sql);
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
