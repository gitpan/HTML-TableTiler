## 1

use Test;
use HTML::TableTiler;
BEGIN {  plan tests => 1 }


$matrix = [[1..5],[6..10],[11..15]];

$expected = << "__EOT__";
<table>
<tr>
	<td>1</td>
	<td>2</td>
	<td>3</td>
	<td>4</td>
	<td>5</td>
</tr>
<tr>
	<td>6</td>
	<td>7</td>
	<td>8</td>
	<td>9</td>
	<td>10</td>
</tr>
<tr>
	<td>11</td>
	<td>12</td>
	<td>13</td>
	<td>14</td>
	<td>15</td>
</tr>
</table>
__EOT__

$tt = new HTML::TableTiler;
$tiled_table = $tt->tile_table($matrix)."\n";

ok ($tiled_table, $expected);