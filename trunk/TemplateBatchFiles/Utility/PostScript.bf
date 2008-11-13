/*---------------------------------------------------------
output a postscript header; set page size
---------------------------------------------------------*/

function _HYPSPageHeader (_width,_height,_doc_title)
{
	
	_res_string = "";
	_res_string * 64;
	_res_string * "%!\n";
	_res_string * ("%% PS file " + _doc_title);
	GetString (_hpv,HYPHY_VERSION,0);
	GetString (_cdt,TIME_STAMP,0);
	_res_string * ("\n%% Generated by HYPHY v" + _hpv + " on GMT " + _cdt);
	_res_string * ("\n<< /PageSize ["+_width+" "+_height+ "] >> setpagedevice");
	_res_string * 0;
	return _res_string;
}


/*---------------------------------------------------------
set a font (face and size)
---------------------------------------------------------*/

function _HYPSSetFont (_font_face,_font_size)
{
	
	_res_string = "";
	_res_string * 64;
	_res_string * ("/"+_font_face+" findfont\n");
	_res_string * ("/fs "+_font_size+" def\nfs scalefont\nsetfont\n");
	_res_string * 0;
	return _res_string;
}

/*---------------------------------------------------------
generates string centering commands

x y (text) centertext - to output (text) so that its center is at (x,y)

x y w (text) scalecentertext - to output (text) so that its center is at (x,y) and is not wider than w

x y (text) righttext - to output (text) so that its right bottom edge is at (x,y)

x y (text) left - to output (text) so that its left bottom edge is at (x,y)

---------------------------------------------------------*/

function _HYPSTextCommands (dummy)
{
	_res_string = "";
	_res_string * 64;
	_res_string * "/centertext {dup newpath 0 0 moveto false charpath closepath pathbbox pop exch pop exch sub 2 div 4 -1 roll exch sub 3 -1 roll newpath moveto show} def\n";
	_res_string * "/vcentertext {90 rotate centertext -90 rotate} def\n";
	_res_string * "/lefttext   {newpath 3 1 roll moveto show} def\n";
	_res_string * "/righttext  {dup newpath 0 0 moveto false charpath closepath pathbbox pop exch pop exch sub       4 -1 roll exch sub 3 -1 roll newpath moveto show} def\n";
	_res_string * "/vrighttext  {3 -2 roll moveto 90 rotate show -90 rotate} def\n";
	_res_string * ("/scalecentertext {dup newpath 0 0 moveto false charpath closepath pathbbox 3 -1 roll sub 3 1 roll exch sub dup 5 -1 roll exch div dup 1 lt " +
				   "{dup 3 1 roll mul 2 div 6 -1 roll exch sub 3 1 roll dup 3 1 roll mul 2 div 5 -1 roll exch sub exch true 4 2 roll} " + 
	               "{pop 2 div 5 -1 roll exch sub exch 2 div 4 -1 roll exch sub false 3 -2 roll} ifelse newpath moveto {matrix currentmatrix exch dup scale exch show setmatrix} {show}  ifelse } def\n");
	_res_string * 0;
	return _res_string;
}
_timesCharWidths = /* Hardcoded relative widths of all 255 characters in the Times font, for the use of _HYPSTextTable */
{{
0,0.721569,0.721569,0.721569,0.721569,0.721569,0.721569,0.721569,0,0.25098,0.721569,0.721569,0.721569,0,0.721569,0.721569,
0.721569,0.721569,0.721569,0.721569,0.721569,0.721569,0.721569,0.721569,0.721569,0.721569,0.721569,0.721569,0.721569,0,0.721569,0.721569,
0.25098,0.333333,0.407843,0.501961,0.501961,0.831373,0.776471,0.180392,0.333333,0.333333,0.501961,0.564706,0.25098,0.333333,0.25098,0.278431,
0.501961,0.501961,0.501961,0.501961,0.501961,0.501961,0.501961,0.501961,0.501961,0.501961,0.278431,0.278431,0.564706,0.564706,0.564706,0.443137,
0.921569,0.721569,0.666667,0.666667,0.721569,0.611765,0.556863,0.721569,0.721569,0.333333,0.388235,0.721569,0.611765,0.890196,0.721569,0.721569,
0.556863,0.721569,0.666667,0.556863,0.611765,0.721569,0.721569,0.945098,0.721569,0.721569,0.611765,0.333333,0.278431,0.333333,0.470588,0.501961,
0.333333,0.443137,0.501961,0.443137,0.501961,0.443137,0.333333,0.501961,0.501961,0.278431,0.278431,0.501961,0.278431,0.776471,0.501961,0.501961,
0.501961,0.501961,0.333333,0.388235,0.278431,0.501961,0.501961,0.721569,0.501961,0.501961,0.443137,0.478431,0.2,0.478431,0.541176,0.721569,
0.721569,0.721569,0.666667,0.611765,0.721569,0.721569,0.721569,0.443137,0.443137,0.443137,0.443137,0.443137,0.443137,0.443137,0.443137,0.443137,
0.443137,0.443137,0.278431,0.278431,0.278431,0.278431,0.501961,0.501961,0.501961,0.501961,0.501961,0.501961,0.501961,0.501961,0.501961,0.501961,
0.501961,0.4,0.501961,0.501961,0.501961,0.34902,0.454902,0.501961,0.760784,0.760784,0.980392,0.333333,0.333333,0.54902,0.890196,0.721569,
0.713725,0.54902,0.54902,0.54902,0.501961,0.576471,0.494118,0.713725,0.823529,0.54902,0.27451,0.27451,0.309804,0.768627,0.666667,0.501961,
0.443137,0.333333,0.564706,0.54902,0.501961,0.54902,0.611765,0.501961,0.501961,1,0.25098,0.721569,0.721569,0.721569,0.890196,0.721569,
0.501961,1,0.443137,0.443137,0.333333,0.333333,0.54902,0.494118,0.501961,0.721569,0.168627,0.745098,0.333333,0.333333,0.556863,0.556863,
0.501961,0.25098,0.333333,0.443137,1,0.721569,0.611765,0.721569,0.611765,0.611765,0.333333,0.333333,0.333333,0.333333,0.721569,0.721569,
0.788235,0.721569,0.721569,0.721569,0.721569,0.278431,0.333333,0.333333,0.333333,0.333333,0.333333,0.333333,0.333333,0.333333,0.333333,0.333333
}};

_timesCharMaxWidth = 0.980392;

_asciiCharString   = "!\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_\`abcdefghijklmnopqrstuvwxyz{|}";
_charWidthForTimes = {};

for (_i = 0; _i < Abs(_asciiCharString); _i=_i+1)
{
	_charWidthForTimes[_asciiCharString[_i]] = _timesCharWidths[33+_i];
}

/*---------------------------------------------------------

genearete a pattern dictionary for a simple hatching pattern

---------------------------------------------------------*/

function _HYPSHatchRectanglePattern (angle,spacing,width,height,color,name,offset_x,offset_y)
{
	_patternDef = "";
	_patternDef * 128;
		
	_patternDef * (""+offset_x+" "+offset_y + " translate\n");	
	_patternDef * "<< % Begin prototype pattern dictionary\n/PaintType 1\n/PatternType 1\n/TilingType 1";
    _patternDef * ("/BBox [0 0 " + width + " " + height + "]\n/XStep "+width+" \n/YStep " + height + "\n/PaintProc\n{\nbegin\n");
	_patternDef * ("" + color[0] + " " + color[1] + " " + color[2] + " setrgbcolor\n");
	
	if (angle != 90)
	{
		_x1 = height/Tan(angle*Arctan(1)/45);
	}
	else
	{
		_x1 = 0;
	}
	_x  = -((1+Abs(_x1)$spacing)*spacing); 
	
	while (_x < width)
	{
		_patternDef * ("\n" + _x + " 0 moveto " + (_x + _x1) + " " + height + " lineto stroke");
		_x = _x + spacing; 
	}
	
	_patternDef * ("\nend\n}\n>>matrix\nmakepattern\n/" + name + " exch def\n");
	_patternDef * ("-"+offset_x+" -"+offset_y + " translate\n");	
	_patternDef * 0;
	return _patternDef;
}


/*---------------------------------------------------------

layout an NxM square text table (one line per cell)
takes in a pair of dimensions, font size, an NxM text matrix
and an NxM integer matrix on whether or not to draw cell boundaries
(masks: 1 for L, 2 for R, 4 for T, 8 for B)

---------------------------------------------------------*/

function _HYPSGetStringWidth (s)
{
	_w = 0;
	for (_i = 0; _i < Abs(s); _i = _i + 1)
	{
		_w = _w + _charWidthForTimes[s[_i]];
	}
	return _w;
}


/*---------------------------------------------------------

layout an NxM square text table (one line per cell)
takes in a pair of dimensions, font size, an NxM text matrix
and an NxM integer matrix on whether or not to draw cell boundaries
(masks: 1 for L, 2 for R, 4 for T, 8 for B)

---------------------------------------------------------*/

function _HYPSTextTable (w,h,fs,tableText,cellBounds)
{
	_res_string = "";
	_res_string * 64;
	
	_columns = Columns(tableText);
	_rows	 = Rows   (tableText);
	_columnWidths = {_columns,1};
	_hBuffer	  = fs * 0.15;
	_cellHeight   = fs + _hBuffer;
	_tH			  = _rows * _cellHeight;
	
	for 	(_i = 0; _i < _rows; _i = _i + 1)
	{
		for 	(_j = 0; _j < _columns; _j = _j + 1)
		{
			_strVal = tableText[_i][_j];
			_strLen = Abs(_strVal);
			_cw		= _timesCharMaxWidth;
			for (_k = 0; _k < _strLen; _k=_k+1)
			{
				_chW = _charWidthForTimes[_strVal[_k]];
				if (_chW)
				{
					_cw = _cw + _chW;
				}
				else
				{
					_cw = _cw + _timesCharMaxWidth;
				}
			}
			_columnWidths[_j] = Max (_columnWidths[_j] , _cw);
		}
	}
	_columnWidths = _columnWidths * fs;
	_tW = ((Transpose(_columnWidths))["1"] * _columnWidths)[0];
	if (_tW < w)
	{
		_tW = (w-_tW) / _columns;
		for 	(_j = 0; _j < _columns; _j = _j + 1)
		{
			_columnWidths[_j] = _columnWidths[_j] + _tW;
		}
		_scale = 1;
	}
	else
	{
		_scale = Min(1,Min(w/_tW,h/_tH));
	}
	if (_scale < 1)
	{
		_res_string * ("" + _scale + " dup scale\n");	
	}
	
	_tH = _tH - _cellHeight;
	for 	(_i = 0; _i < _rows; _i = _i + 1)
	{
		_currentLeft = 0;
		for 	(_j = 0; _j < _columns; _j = _j + 1)
		{
			_res_string * ("" + (_currentLeft+_timesCharMaxWidth*fs/2) + " " + (_tH+2*_hBuffer)  + " (" + tableText[_i][_j] + ") lefttext\n");
			cellMarker = cellBounds[_i][_j];
			_currentRight = _currentLeft + _columnWidths[_j];
			if (cellMarker % 2 == 1) /* left */
			{
				_res_string * ("newpath " + _currentLeft + " " + _tH + " moveto 0 " + _cellHeight + " rlineto stroke\n");
			}
			cellMarker = cellMarker$2;
			if (cellMarker % 2 == 1) /* right */
			{
				_res_string * ("newpath " + _currentRight + " " + _tH + " moveto 0 " + _cellHeight + " rlineto stroke\n");
			}
			cellMarker = cellMarker$2;
			if (cellMarker % 2 == 1) /* top */
			{
				_res_string * ("newpath " + _currentLeft + " " + (_tH+_cellHeight)  + " moveto " + _columnWidths[_j] + " 0 rlineto stroke\n");
			}
			cellMarker = cellMarker$2;
			if (cellMarker % 2 == 1) /* bottom */
			{
				_res_string * ("newpath " + _currentLeft + " " + (_tH)  + " moveto " + _columnWidths[_j] + " 0 rlineto stroke\n");
			}
			_currentLeft = _currentRight;
		}
		/* do the border now */
		_tH = _tH - _cellHeight;
	}
	
	
	if (_scale < 1)
	{
		_res_string * ("" + 1/_scale + " dup scale\n");	
	}
	_res_string * 0;
	return _res_string;	
}

/*---------------------------------------------------------

draw a sequence profile box: colored (and labeled) 
partitioned rectangles

+-------------+-----------+-------+
|  A (100bp)  | B (200bp) |A(100bp|
+-------------+-----------+-------+

takes dimensions _w and _h, font size _f an Nx2 matrix with partition 
width labels (1st row) and proportional widths (2nd row) and an Nx6 matrix 
with the colors (RGB for the background and RGB for the text)

---------------------------------------------------------*/

_hyDefaultPSColors =
{
{102,51,51}
{153,204,153}
{102,0,153}
{153,0,153}
{255,51,51}
{102,0,153}
{255,204,0}
{153,255,153}
{102,153,51}
{102,204,102}
{0,51,153}
{255,102,0}
{153,153,51}
{255,153,0}
{153,51,102}
{153,153,153}
{102,102,153}
{153,51,51}
{204,51,51}
{102,153,102}
}*(1/255);

_hyDefaultGS =
{6,3}["(220-_MATRIX_ELEMENT_ROW_*30)/255"];

function _HYPSLabeledBoxes (_x, _y, _f, _boxes, _colors)
{
	_res_string = "";
	_res_string * 64;
	_box_dimensions = {};
	_partCount = Rows(_boxes);
	if (_partCount)
	{
		if (Columns(_colors) == 6 && Rows(_colors) == _partCount)
		{
			_res_string * "currentrgbcolor\n";
			_currentX 			= 0;
			_textLocation 		= _y/2;
			
			for 	(_i = 0; _i < _partCount; _i = _i + 1)
			{
				_res_string * ("" + _colors[_i][0] + " " + _colors[_i][1] + " " + _colors[_i][2] + " setrgbcolor\n");
				_boxWidth = (0+_boxes[_i][1])*_x;
				_res_string * ("" + _currentX + " 0 " + _boxWidth + " " + _y + " rectfill\n");
				_res_string * ("" + _colors[_i][3] + " " + _colors[_i][4] + " " + _colors[_i][5] + " setrgbcolor\n");
				_res_string * ("" + (_currentX + _boxWidth/2) + " " + _textLocation + " " + _boxWidth + " (" + _boxes[_i][0] + ") scalecentertext\n");
				_box_dimensions[_i] = {{_currentX__,_boxWidth__,_y}};
				_currentX = _currentX + _boxWidth;
			}
		}
		_res_string * "0 0 0 setrgbcolor currentlinewidth 1 setlinewidth\n";
		_res_string * ("0 0 "+ (_x) + " " + (_y) + " rectstroke setlinewidth\n");
		_res_string * "setrgbcolor\n";
	}
	_res_string * 0;
	_retValue = {};
	_retValue["PS"] 		= _res_string;
	_retValue["Dimensions"] = _box_dimensions;
	return _retValue;
}


