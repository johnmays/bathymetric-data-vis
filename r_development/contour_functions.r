get_bathymetry_tile <- function(xmin, xmax, ymin, ymax, resx = 1, resy = 1,
                                quiet = FALSE) {
  name <- "emodnet:mean"
  bounding_box <- paste(xmin, ymin, xmax, ymax, sep = ",")
  url <- paste("https://ows.emodnet-bathymetry.eu/wcs?service=wcs&version=1.0.0&request=getcoverage&coverage=",
               name, "&crs=EPSG:4326&BBOX=", bounding_box,
               "&format=image/tiff&interpolation=nearest&resx=", resx, "&resy=", resy,
               sep = "")
  if (!quiet) cat(paste("Full Request URL:", url))
  temp <- paste(name, "img.tiff", sep = "_")
  temp <- tempfile(temp)
  download.file(url, temp, quiet = FALSE, mode = "wb")
  img_raw <- raster::raster(temp)
  img_raw <- -1 * img_raw
  img_raw[img_raw < 0] <- 0 # (any heights above sea level become 0)
  img_raw[img_raw == 0] <- NaN # (any coastlines are marked with NaN)
  return(img_raw)
}

# METHOD 1 FUNCTION(S):
contour_fill_mapping <- function(n, interval = 100) {
  return(interval * (floor(n / interval)))
}

contour_transform <- function(img, interval = 100) {
  img_copy <- as.matrix(img) # S4 to matrix
  img_copy <- apply(img_copy, c(1, 2), 
                    function(x) contour_fill_mapping(x, interval = interval))
  return(img_copy)
}

# METHOD 2 FUNCTION(S):
stitch_tiles <- function(xmin, xmax, ymin, ymax, tile_size = 2.5, res = 100) {
  # @param: xmin, xmax, ymin, ymax should be a bounding box of latitude
  # and longitude
  # @param: tile_size should be a double in degrees such that describes how
  # large the tiles should be.  E.g: 2.5 => 2.5x2.5 degree tile of earth
  # @param: res should be values per degree.  E.g. 100 => there will be
  # 100x100 = 10,000 samples in a 1 degree by 1 degree tile.
  # @return: a matrix containing these tiles stitched together

  width_degrees <- xmax - xmin # width of entire area in degrees
  height_degrees <- ymax - ymin # height ''
  width_pixels <- width_degrees * res # width of entire area in pixels
  height_pixels <- height_degrees * res # height ''
  width_tiles <- ceiling(width_degrees / tile_size) # width of area in tiles
  height_tiles <- ceiling(height_degrees / tile_size) # height ''
  total_tiles <- width_tiles * height_tiles # total number of tiles
  tile_size_pixels <- tile_size * res # length of tile side in pixels

  cat(paste("The resulting image will be", width_degrees, "deg wide by",
            height_degrees, "deg tall,\n"))
  cat(paste(width_pixels, "pixels wide by", height_pixels, "pixels tall,\n"))
  cat(paste("and", width_tiles, "tiles wide by", height_tiles,
            "tiles tall.\n"))
  cat(paste("That's", total_tiles, "total tiles.\n"))

  stitched_img <- matrix(0, height_pixels, width_pixels)

  cat("Beginning Stitching Process")
  Sys.sleep(0.1)
  p_bar <- txtProgressBar(style = 3)
  # This will be confusing: we are proceeding left to right, top to bottom
  # We finish one row, then move on to the next
  # But, matrices are accessed s.t. the top left corner is [0,0]
  # So "min" and "max" have different meanings, depending on the context
  for (row in 1:height_tiles) {
    # degree vars for data request:
    ymax_temp <- ymax - ((row - 1) * tile_size)
    ymin_temp <- ymax - (row * tile_size)
    # pixel vars for image:
    ymin_pixels <- 1 + ((row - 1) * tile_size_pixels)
    ymax_pixels <- (row * tile_size_pixels)
    for (col in 1:width_tiles) {
      # degree vars for data request:
      xmin_temp <- xmin + ((col - 1) * tile_size)
      xmax_temp <- xmin + (col * tile_size)
      # pixel vars for image:
      xmin_pixels <- 1 + ((col - 1) * tile_size_pixels)
      xmax_pixels <- (col * tile_size_pixels)
      # {request and assignment here}
      res_param <- 1.0 / res
      tile <- get_bathymetry_tile(xmin_temp, xmax_temp, ymin_temp, ymax_temp,
                                  resx = res_param, resy = res_param,
                                  quiet = TRUE)
      stitched_img[ymin_pixels:ymax_pixels, xmin_pixels:xmax_pixels] <-
        as.matrix(tile)
      tile_num <- (row - 1) * width_tiles + col # what tile we are on
      setTxtProgressBar(p_bar, tile_num / total_tiles)
      Sys.sleep(2)
    }
  }
  Sys.sleep(0.5)
  close(p_bar)
  Sys.sleep(0.5)
  cat("Finished")
  return(stitched_img)
}