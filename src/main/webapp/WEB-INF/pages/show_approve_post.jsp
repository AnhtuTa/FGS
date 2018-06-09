
<c:if test="${not empty postList}">
    <jsp:useBean id="fp" class="hello.util.FormatPrice"/>
    <div class="approve_post_wrapper" id="approve_post_wrapper">
        <c:forEach items="${postList}" var="post">
            <div class="approve_post_item">
                <table>
                    <tr>
                        <td>Poster</td>
                        <td>
                            <c:if test="${post.contactName != null}">${post.contactName}</c:if>
                            <c:if test="${post.contactName == null}">Unknown</c:if>
                        </td>
                    </tr>
                    <tr>
                        <td>Post's time</td>
                        <td>
                            <c:if test="${sessionScope.localeString == 'en'}">${post.getFormattedTimeUS()}</c:if>
                            <c:if test="${sessionScope.localeString == 'vi'}">${post.getFormattedTimeVN()}</c:if>
                        </td>
                    </tr>
                    <tr>
                        <td>Title</td>
                        <td>${post.name}</td>
                    </tr>
                    <tr>
                        <td>Description</td>
                        <td>${post.description}</td>
                    </tr>
                    <tr>
                        <td>Area</td>
                        <td>${post.area}</td>
                    </tr>
                    <tr>
                        <td>Price</td>
                        <td>${fp.formatPrice(post.price)} đ/tháng</td>
                    </tr>
                    <tr>
                        <td>Address</td>
                        <td>${post.street}, ${post.district}, ${post.city}</td>
                    </tr>
                    <tr>
                        <td>Contact</td>
                        <td>
                            <div>Phone: ${post.contactPhone}</div>
                            <div>Email: ${post.contactEmail}</div>
                            <div>Address: ${post.contactAddress}</div>
                        </td>
                    </tr>
                </table>
            </div>
        </c:forEach>
    </div>
</c:if>