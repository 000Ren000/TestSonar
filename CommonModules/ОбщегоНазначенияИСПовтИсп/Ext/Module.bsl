﻿
#Область СлужебныйПрограммныйИнтерфейс

// Определяет включено ли ведение учета продукции, подлежащей маркированию.
//
// Параметры:
// 	РасширеннаяВерсияГосИС - Булево
// Возвращаемое значение:
//  Булево - Истина, если учет ведется.
Функция ВедетсяУчетМаркируемойПродукции(РасширеннаяВерсияГосИС) Экспорт
	
	Если РасширеннаяВерсияГосИС Тогда
		
		Модуль = ОбщегоНазначения.ОбщийМодуль("ШтрихкодированиеИС");
		УчитываемыеВидыМаркируемойПродукции = Модуль.УчитываемыеВидыМаркируемойПродукции();
		
		Возврат УчитываемыеВидыМаркируемойПродукции.Количество() > 0;
		
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

// Возвращает признак принадлежности переданного в параметре вида продукции к виду продукции ИС МП.
// 
// Параметры:
// 	ВидПродукции              - ПеречислениеСсылка.ВидыПродукцииИС - Вид продукции для анализа.
// 	ВключаяТабачнуюПродукцию  - Булево                             - Признак включения табачной продукции.
// 	ВключатьМолочнуюПродукцию - Булево                             - Признак включения молочной продукции.
// 	ВключатьПиво              - Булево                             - Признак включения пивной продукции.
// Возвращаемое значение:
// 	Булево - Принадлежность к виду продукции ИСМП
//
Функция ЭтоПродукцияИСМП(ВидПродукции, ВключаяТабачнуюПродукцию = Ложь, ВключатьМолочнуюПродукцию = Истина, ВключатьПиво = Истина) Экспорт
	
	ВидыПродукцииИСМП = ОбщегоНазначенияИСКлиентСервер.ВидыПродукцииИСМП(ВключаяТабачнуюПродукцию, ВключатьМолочнуюПродукцию, ВключатьПиво);
	
	Возврат ВидыПродукцииИСМП.Найти(ВидПродукции) <> Неопределено;
	
КонецФункции

// Возвращает признак принадлежности переданного в параметре вида продукции к табачной продукции.
// 
// Параметры:
// 	ВидПродукции              - ПеречислениеСсылка.ВидыПродукцииИС - Вид продукции для анализа.
// Возвращаемое значение:
// 	Булево - Принадлежность к виду продукции ИСМП
//
Функция ЭтоПродукцияМОТП(ВидПродукции) Экспорт
	
	Возврат ОбщегоНазначенияИСКлиентСервер.ЭтоПродукцияМОТП(ВидПродукции);
	
КонецФункции

// Классифицирует текущий сеанс, как сеанс, запущенный в фоновом задании в клиент-серверном варианте, в остальных
// случаях, сеанс имеет ту же файловую систему на стороне сервера, что и основной сеанс.
//	
// Возвращаемое значение:
// 	Булево - Описание
Функция ЭтоФоновоеЗаданиеНаСервере() Экспорт
	Возврат ОбщегоНазначенияИСВызовСервера.ЭтоФоновоеЗаданиеНаСервере();
КонецФункции

// Возвращает объект ЗащищенноеСоединениеOpenSSL
// 
// Возвращаемое значение:
// 	ЗащищенноеСоединениеOpenSSL - Описание
Функция ЗащищенноеСоединение() Экспорт
	
	Возврат ОбщегоНазначенияКлиентСервер.НовоеЗащищенноеСоединение();
	
КонецФункции

#КонецОбласти