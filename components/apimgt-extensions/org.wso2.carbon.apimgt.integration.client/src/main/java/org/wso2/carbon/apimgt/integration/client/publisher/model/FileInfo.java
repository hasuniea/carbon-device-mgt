/**
 * WSO2 API Manager - Publisher API
 * This document specifies a **RESTful API** for WSO2 **API Manager** - Publisher.  It is written with [swagger 2](http://swagger.io/). 
 *
 * OpenAPI spec version: 0.10.0
 * Contact: architecture@wso2.com
 *
 * NOTE: This class is auto generated by the swagger code generator program.
 * https://github.com/swagger-api/swagger-codegen.git
 * Do not edit the class manually.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


package org.wso2.carbon.apimgt.integration.client.publisher.model;

import com.fasterxml.jackson.annotation.JsonProperty;
import io.swagger.annotations.ApiModelProperty;

import java.util.Objects;


/**
 * FileInfo
 */
@javax.annotation.Generated(value = "class io.swagger.codegen.languages.JavaClientCodegen", date = "2017-01-24T00:03:49.624+05:30")
public class FileInfo   {
  @JsonProperty("relativePath")
  private String relativePath = null;

  @JsonProperty("mediaType")
  private String mediaType = null;

  public FileInfo relativePath(String relativePath) {
    this.relativePath = relativePath;
    return this;
  }

   /**
   * relative location of the file (excluding the base context and host of the Publisher API)
   * @return relativePath
  **/
  @ApiModelProperty(example = "apis/01234567-0123-0123-0123-012345678901/thumbnail", value = "relative location of the file (excluding the base context and host of the Publisher API)")
  public String getRelativePath() {
    return relativePath;
  }

  public void setRelativePath(String relativePath) {
    this.relativePath = relativePath;
  }

  public FileInfo mediaType(String mediaType) {
    this.mediaType = mediaType;
    return this;
  }

   /**
   * media-type of the file
   * @return mediaType
  **/
  @ApiModelProperty(example = "image/jpeg", value = "media-type of the file")
  public String getMediaType() {
    return mediaType;
  }

  public void setMediaType(String mediaType) {
    this.mediaType = mediaType;
  }


  @Override
  public boolean equals(Object o) {
    if (this == o) {
      return true;
    }
    if (o == null || getClass() != o.getClass()) {
      return false;
    }
    FileInfo fileInfo = (FileInfo) o;
    return Objects.equals(this.relativePath, fileInfo.relativePath) &&
        Objects.equals(this.mediaType, fileInfo.mediaType);
  }

  @Override
  public int hashCode() {
    return Objects.hash(relativePath, mediaType);
  }

  @Override
  public String toString() {
    StringBuilder sb = new StringBuilder();
    sb.append("class FileInfo {\n");

    sb.append("    relativePath: ").append(toIndentedString(relativePath)).append("\n");
    sb.append("    mediaType: ").append(toIndentedString(mediaType)).append("\n");
    sb.append("}");
    return sb.toString();
  }

  /**
   * Convert the given object to string with each line indented by 4 spaces
   * (except the first line).
   */
  private String toIndentedString(Object o) {
    if (o == null) {
      return "null";
    }
    return o.toString().replace("\n", "\n    ");
  }
}
