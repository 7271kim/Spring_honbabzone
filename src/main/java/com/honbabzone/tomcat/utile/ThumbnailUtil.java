package com.honbabzone.tomcat.utile;

import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;

import javax.imageio.ImageIO;

public class ThumbnailUtil {

	public static final int SAME = -1;
	public static final int RATIO = 0;

	/**
	 * <b>File to Thumbnail File</b>
	 * 
	 * @discription 원본 이미지를 썸네일 File로 생성한다.
	 * 
	 * @param src
	 *            원본 이미지 파일
	 * @param dest
	 *            썸네일 이미지 파일
	 * @param width
	 *            변경 width
	 * @param height
	 *            변경 height
	 * @throws IOException
	 */
	public static void makeThumbnail(File src, File dest, int width, int height)
			throws IOException {
		FileInputStream srcIs = null;

		try {
			srcIs = new FileInputStream(src);
			ThumbnailUtil.makeThumbnail(srcIs, dest, width, height);
		} finally {
			if (srcIs != null) {
				try {
					srcIs.close();
				} catch (IOException ioe) {
					ioe.printStackTrace();
				}
			}
		}
	}

	/**
	 * <b>File to Thumbnail File</b>
	 * 
	 * @discription 원본 이미지를 썸네일 File로 생성한다.
	 * 
	 * @param src
	 *            원본 이미지 파일
	 * @param dest
	 *            썸네일 이미지 파일
	 * @param method
	 *            가로중심 : w, 세로중심 : h
	 * @param size
	 *            변경 size
	 * @throws IOException
	 */
	public static void makeThumbnail(File src, File dest, String method,
			int size) throws IOException {
		FileInputStream srcIs = null;

		int image_width = 0;
		int image_height = 0;
		int width = 0;
		int height = 0;

		try {
			File file = new File(src.getPath());
			BufferedImage bi = ImageIO.read(file);
			image_width = bi.getWidth();
			image_height = bi.getHeight();
			
			if ("w".equals(method)) {
				width = size;
				height = (size * image_height) / image_width;
			} else if ("h".equals(method)) {
				height = size;
				width = (size * image_width) / image_height;
			}

			srcIs = new FileInputStream(src);
			ThumbnailUtil.makeThumbnail(srcIs, dest, width, height);
		} finally {
			if (srcIs != null) {
				try {
					srcIs.close();
				} catch (IOException ioe) {
					ioe.printStackTrace();
				}
			}
		}
	}

	/**
	 * <b>InputStream to Thumbnail File</b>
	 * 
	 * @discription 원본 이미지 File의 Stream 을 썸네일 File로 생성한다.
	 * 
	 * @param src
	 *            원본 이미지 파일의 Stream
	 * @param dest
	 *            썸네일 이미지 파일
	 * @param width
	 *            변경 width
	 * @param height
	 *            변경 height
	 * @throws IOException
	 */
	public static void makeThumbnail(InputStream src, File dest, int width,
			int height) throws IOException {

		// 원본 이미지 정보 할당
		BufferedImage srcImg = ImageIO.read(src);

		// 원본 이미지 폭과 높이 설정
		int srcWidth = srcImg.getWidth();
		int srcHeight = srcImg.getHeight();

		/***************************************
		 * 썸네일 이미지의 폭과 높이 구하기 - s
		 ***************************************/
		int destWidth = -1;
		int destHeight = -1;

		if (width == SAME) {
			destWidth = srcWidth;
		} else if (width > 0) {
			destWidth = width;
		}

		if (height == SAME) {
			destHeight = srcHeight;
		} else if (width > 0) {
			destHeight = height;
		}

		if (width == RATIO && height == RATIO) {
			destWidth = srcWidth;
			destHeight = srcHeight;
		} else if (width == RATIO) {
			double ratio = ((double) destHeight) / ((double) destHeight);
			destWidth = (int) ((double) srcWidth * ratio);
		} else if (height == RATIO) {
			double ratio = ((double) destWidth) / ((double) destWidth);
			destHeight = (int) ((double) srcHeight * ratio);
		}
		/***************************************/

		// 새로 생성할 이미지 정보 할당
		BufferedImage destImg = new BufferedImage(destWidth, destHeight,
				BufferedImage.TYPE_3BYTE_BGR);

		// 썸네일 이미지 그리기
		Graphics2D g = destImg.createGraphics();
		g.drawImage(srcImg, 0, 0, destWidth, destHeight, null);

		// 이미지 생성
		ImageIO.write(destImg, "png", dest);
	}

}
