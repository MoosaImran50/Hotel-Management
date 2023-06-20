<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="Bookings.aspx.cs" Inherits="HotelManagement.WebForm9" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
   <script type="text/javascript">
      $(document).ready(function () {
          $(".table").prepend($("<thead></thead>").append($(this).find("tr:first"))).dataTable();
      });
   </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container">
      <div class="row">
         <div class="col-md-5">
            <div class="card">
               <div class="card-body">
                   <div class="row">
                     <div class="col">
                        <center>
                           <h4>Cancel Booking</h4>
                        </center>
                     </div>
                  </div>
                  <div class="row">
                     <div class="col">
                        <center>
                           <img width="100px" src="imgs/cancelbooking2.png" />
                        </center>
                     </div>
                  </div>

                  <div class="row">
                     <div class="col">
                        <hr>
                     </div>
                  </div>
                  <div class="row">
                     <div class="col-md-12">
                        <label>Booking ID</label>
                        <div class="form-group">
                           <div class="input-group">
                              <asp:TextBox CssClass="form-control" ID="TextBox1" runat="server" placeholder="ID"></asp:TextBox>
                           </div>
                        </div>
                     </div>
                  </div>
                                 <div class="col-12">
                <asp:Button ID="Button1" class="btn btn-lg btn-block btn-primary" runat="server" Text="Apply" OnClick="Button1_Click" />
                </div>
            </div>
               </div>
         </div>




         <div class="col-md-7">
            <div class="card">
               <div class="card-body">
                    <div class="row">
                     <div class="col">
                        <center>
                           <h4>Booking List</h4>
                        </center>
                     </div>
                  </div>
                  <div class="row">
                     <div class="col">
                        <hr>
                     </div>
                  </div>
                  <div class="row">
                      <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:hotel1ConnectionString1 %>" SelectCommand="SELECT * FROM [Booking]"></asp:SqlDataSource>
                     <div class="col">
                        <asp:GridView class="table table-striped table-bordered" ID="GridView1" runat="server" AutoGenerateColumns="False" DataKeyNames="BookingId" DataSourceID="SqlDataSource1">
                            <Columns>
                                <asp:BoundField DataField="BookingId" HeaderText="BookingId" ReadOnly="True" SortExpression="BookingId" />
                                <asp:BoundField DataField="UserId" HeaderText="UserId" SortExpression="UserId" />
                                <asp:BoundField DataField="HotelId" HeaderText="HotelId" SortExpression="HotelId" />
                                <asp:BoundField DataField="RoomId" HeaderText="RoomId" SortExpression="RoomId" />
                                <asp:BoundField DataField="BookingDate" HeaderText="BookingDate" SortExpression="BookingDate" />
                            </Columns>
                         </asp:GridView>
                         <asp:SqlDataSource ID="SqlDataSource2" runat="server"></asp:SqlDataSource>
                     </div>
                  </div>
               </div>
            </div>
         </div>
    </div>
</div>
</asp:Content>
