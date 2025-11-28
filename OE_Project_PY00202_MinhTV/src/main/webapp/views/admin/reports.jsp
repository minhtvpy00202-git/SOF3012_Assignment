<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>


<!-- START: Tabs wrapper -->
<div class="reports-tabs">


  <!-- radios (one per tab) - checked server-side based on params -->
  <input type="radio" id="tab1" name="reportsTab"
    <c:if test="${empty param.videoId and empty param.shareVideoId}">checked</c:if> />

  <input type="radio" id="tab2" name="reportsTab"
    <c:if test="${not empty param.videoId}">checked</c:if> />

  <input type="radio" id="tab3" name="reportsTab"
    <c:if test="${not empty param.shareVideoId}">checked</c:if> />

  <!-- labels = tab headers -->
  <div class="tabs-labels">
    <label for="tab1">FAVORITES</label>
    <label for="tab2">FAVORITE USERS</label>
    <label for="tab3">SHARE FRIENDS</label>
  </div>

  <!-- content area -->
  <div class="tab-content">

    <!-- TAB 1: Tổng hợp favorite -->
    <div id="panel1" class="panel">
      <h3 class="admin-subtitle">1. Thống kê số người yêu thích từng tiểu phẩm</h3>

      <table class="admin-table">
        <thead>
          <tr>
            <th>Video Title</th>
            <th>Favorite Count</th>
            <th>Latest Date</th>
            <th>Oldest Date</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="r" items="${favoriteReports}">
            <tr>
              <td>${r[0]}</td>
              <td>${r[1]}</td>
              <td><fmt:formatDate value="${r[2]}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
              <td><fmt:formatDate value="${r[3]}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </div>

    <!-- TAB 2: Favorite users filtered -->
    <div id="panel2" class="panel">
      <h3 class="admin-subtitle">2. Lọc người dùng yêu thích theo tiểu phẩm</h3>

      <div class="filter-box">
        <form class="admin-form" method="get" action="${pageContext.request.contextPath}/admin/reports">
          <div class="admin-form-row">
            <label>Chọn Video:</label>
            <select name="videoId" onchange="this.form.submit()">
              <option value="">-- Chọn --</option>
              <c:forEach var="v" items="${videos}">
                <option value="${v.id}" ${param.videoId == v.id ? "selected" : ""}>
                  ${v.title}
                </option>
              </c:forEach>
            </select>
          </div>
          <div class="admin-form-actions">
            <button class="btn btn-primary" type="submit">Lọc</button>
          </div>
        </form>
      </div>

      <table class="admin-table">
        <thead>
          <tr>
            <th>Username</th>
            <th>Fullname</th>
            <th>Email</th>
            <th>Favorite Date</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="f" items="${favoriteUsers}">
            <tr>
              <td>${f.user.id}</td>
              <td>${f.user.fullname}</td>
              <td>${f.user.email}</td>
              <td><fmt:formatDate value="${f.likeDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </div>

    <!-- TAB 3: Share reports filtered -->
    <div id="panel3" class="panel">
      <h3 class="admin-subtitle">3. Lọc người chia sẻ theo tiểu phẩm</h3>

      <div class="filter-box">
        <form class="admin-form" method="get" action="${pageContext.request.contextPath}/admin/reports">
          <div class="admin-form-row">
            <label>Chọn Video:</label>
            <select name="shareVideoId" onchange="this.form.submit()">
              <option value="">-- Chọn --</option>
              <c:forEach var="v" items="${videosShare}">
                <option value="${v.id}" ${param.shareVideoId == v.id ? "selected" : ""}>
                  ${v.title}
                </option>
              </c:forEach>
            </select>
          </div>
          <div class="admin-form-actions">
            <button class="btn btn-primary" type="submit">Lọc</button>
          </div>
        </form>
      </div>

      <table class="admin-table">
        <thead>
          <tr>
            <th>Sender Username</th>
            <th>Sender Email</th>
            <th>Receiver Email</th>
            <th>Sent Date</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="s" items="${shareReports}">
            <tr>
              <td>${s.user.id}</td>
              <td>${s.user.email}</td>
              <td>${s.email}</td>
              <td><fmt:formatDate value="${s.shareDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </div>

  </div> <!-- .tab-content -->
</div> <!-- .reports-tabs -->
<!-- END: Tabs wrapper -->

