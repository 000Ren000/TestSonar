﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Автотест") Тогда
		Возврат;
	КонецЕсли;
	
	// Соответствие значений перечисления строковым именам значений
	СоответствиеТипов = Новый Соответствие;
	ЗначенияПеречисления = Метаданные.Перечисления.ТипыДанныхУчета.ЗначенияПеречисления;
	СоответствиеТипов.Вставить(Перечисления.ТипыДанныхУчета.ПустаяСсылка(), "");
	Для Каждого Значение Из ЗначенияПеречисления Цикл
		Имя = Значение.Имя;
		СоответствиеТипов.Вставить(Перечисления.ТипыДанныхУчета[Имя], Имя);
	КонецЦикла;
	ТипДанныхУчетаСтрокой = Новый ФиксированноеСоответствие(СоответствиеТипов);
	
	// Соответствие значений перечисления строковым именам значений
	СоответствиеТипов = Новый Соответствие;
	ЗначенияПеречисления = Метаданные.Перечисления.ПоказателиАналитическихРегистров.ЗначенияПеречисления;
	СоответствиеТипов.Вставить(Перечисления.ПоказателиАналитическихРегистров.ПустаяСсылка(), "");
	Для Каждого Значение Из ЗначенияПеречисления Цикл
		Имя = Значение.Имя;
		СоответствиеТипов.Вставить(Перечисления.ПоказателиАналитическихРегистров[Имя], Имя);
	КонецЦикла;
	ПоказателиРегистровСтрокой = Новый ФиксированноеСоответствие(СоответствиеТипов);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормыЭлемента = Новый Структура;
	ПараметрыФормыЭлемента.Вставить("РучнаяНастройка");
	ПараметрыФормыЭлемента.Вставить("Ключ", ВыбраннаяСтрока);
	
	ОткрытьФорму("Справочник.НастройкиХозяйственныхОпераций.ФормаОбъекта", ПараметрыФормыЭлемента, ЭтотОбъект); 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СформироватьКодОбработчика(Команда)
	
	СформироватьКодОбработчикаНаСервере();
	
	ТекстДок = Новый ТекстовыйДокумент;
	ТекстДок.УстановитьТекст(Код1С.ПолучитьТекст());
	ТекстДок.Показать("ПриНачальномЗаполненииЭлементов");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПредопределенныеЭлементы(Команда)
	
	ЗаполнитьНастройкиНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СформироватьКодОбработчикаНаСервере()
	
	НастройкиПредопределенных = НастройкиПредопределенныхЭлементов();
	ПоказателиРегистра = ПоказателиРегистра();
	СвязанныеДокументы = СвязанныеДокументы();
	ФункциональныеОпции = ФункциональныеОпции();
	Код1С.Очистить();
	
	Код1С.ДобавитьСтроку("Процедура ПриНачальномЗаполненииЭлементов(КодыЯзыков, Элементы, ТабличныеЧасти) Экспорт" + Символы.ПС);
	Код1С.ДобавитьСтроку("	КодОсновногоЯзыка = ОбщегоНазначения.КодОсновногоЯзыка();" + Символы.ПС);
	ТабличныеЧасти = Новый Структура;
	ТабличныеЧасти.Вставить("ПоказателиРегистра", ПоказателиРегистра);
	ТабличныеЧасти.Вставить("Документы", СвязанныеДокументы);
	ТабличныеЧасти.Вставить("ФункциональныеОпции", ФункциональныеОпции);
	ДобавитьКодЭлемента(НастройкиПредопределенных, ТабличныеЧасти);
	
	Код1С.ДобавитьСтроку("КонецПроцедуры");
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьКодЭлемента(Родитель, ТабличныеЧасти, Отступ = "	")
	
	ДвойнойОбратныйСлэш = "//";
	Для Каждого Элемент Из Родитель.Строки Цикл
		
		Если Элемент.ЭтоГруппа Тогда
			Код1С.ДобавитьСтроку(СтрШаблон("%1#Область %2", Отступ, Элемент.ID));
			Код1С.ДобавитьСтроку(СтрШаблон("%1Элемент = Элементы.Добавить();  %2 см. СтрокаТЧПредопреденногоЭлемента", Отступ, ДвойнойОбратныйСлэш));
			Код1С.ДобавитьСтроку(СтрШаблон("%1Элемент.ИмяПредопределенныхДанных = ""%2"";", Отступ, Элемент.ID));
			Если ЗначениеЗаполнено(Элемент.Родитель) Тогда
				Код1С.ДобавитьСтроку(СтрШаблон("%1Элемент.Родитель = Справочники.НастройкиХозяйственныхОпераций.%2;", Отступ, Элемент.Родитель.ID));
			КонецЕсли;
			Код1С.ДобавитьСтроку(СтрШаблон("%1МультиязычностьСервер.ЗаполнитьМультиязычныйРеквизит(Элемент, ""Наименование"", ""ru = '%2'"", КодыЯзыков); %3 @НСтр-2" + Символы.ПС, Отступ, Элемент.Наименование, ДвойнойОбратныйСлэш));
			ДобавитьКодЭлемента(Элемент, ТабличныеЧасти, Символы.Таб + Отступ);
			Код1С.ДобавитьСтроку(СтрШаблон("%1#КонецОбласти %2%3" + Символы.ПС, Отступ, ДвойнойОбратныйСлэш, Элемент.ID));
			Продолжить;
		КонецЕсли;
		
		Код1С.ДобавитьСтроку(СтрШаблон("%1#Область %2", Отступ, Элемент.ID));
		Код1С.ДобавитьСтроку(СтрШаблон("%1Элемент = Элементы.Добавить(); %2 см. СтрокаТЧПредопреденногоЭлемента", Отступ, ДвойнойОбратныйСлэш));
		Код1С.ДобавитьСтроку(СтрШаблон("%1Элемент.ИмяПредопределенныхДанных = ""%2"";", Отступ, Элемент.ID));
		Код1С.ДобавитьСтроку(СтрШаблон("%1Элемент.Родитель = Справочники.НастройкиХозяйственныхОпераций.%2;", Отступ, Родитель.ID));
		НаименованиеЭлемента = СтрЗаменить(Элемент.Наименование,"""","""""");
		Код1С.ДобавитьСтроку(СтрШаблон("%1МультиязычностьСервер.ЗаполнитьМультиязычныйРеквизит(Элемент, ""Наименование"", ""ru = '%2'"", КодыЯзыков); %3 @НСтр-2", Отступ, НаименованиеЭлемента, ДвойнойОбратныйСлэш));
		Код1С.ДобавитьСтроку(СтрШаблон("%1Элемент.ИсточникДанных = ""%2"";", Отступ, Элемент.ИсточникДанных));
		ПредставлениеИсточникаДанных = СтрЗаменить(Элемент.ПредставлениеИсточникаДанных,"""","""""");
		Если ПустаяСтрока(ПредставлениеИсточникаДанных) Тогда
			Код1С.ДобавитьСтроку(СтрШаблон("%1Элемент.ПредставлениеИсточникаДанных = """";", Отступ));
		Иначе
			Код1С.ДобавитьСтроку(СтрШаблон("%1Элемент.ПредставлениеИсточникаДанных = НСтр(""ru = '%2'"", КодОсновногоЯзыка);", Отступ, ПредставлениеИсточникаДанных));
		КонецЕсли;
		
		Описание = СтрШаблон("%1Элемент.Описание = """";", Отступ);
		Если НЕ ПустаяСтрока(Элемент.Описание) Тогда
			Описание = СтрШаблон("%1Элемент.Описание = НСтр(""ru = '%2'"", КодОсновногоЯзыка);", Отступ, СтрЗаменить(Элемент.Описание,"""",""""""));
		КонецЕсли;
		Код1С.ДобавитьСтроку(Описание);
		
		Приход = СтрШаблон("%1Элемент.Приход = Неопределено;", Отступ);
		Если ЗначениеЗаполнено(Элемент.Приход) Тогда
			Приход = СтрШаблон("%1Элемент.Приход = Перечисления.ТипыДанныхУчета.%2;", Отступ, ТипДанныхУчетаСтрокой[Элемент.Приход]);
		КонецЕсли;
		Код1С.ДобавитьСтроку(Приход);
		
		Расход = СтрШаблон("%1Элемент.Расход = Неопределено;", Отступ);
		Если ЗначениеЗаполнено(Элемент.Расход) Тогда
			Расход = СтрШаблон("%1Элемент.Расход = Перечисления.ТипыДанныхУчета.%2;", Отступ, ТипДанныхУчетаСтрокой[Элемент.Расход]);
		КонецЕсли;
		Код1С.ДобавитьСтроку(Расход);
		
		Код1С.ДобавитьСтроку(СтрШаблон("%1Элемент.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.%2;", Отступ, Элемент.ХозяйственнаяОперация));
		Код1С.ДобавитьСтроку(СтрШаблон("%1Элемент.ИспользоватьВБюджетировании = %2;", Отступ, Элемент.ИспользоватьВБюджетировании));
		Код1С.ДобавитьСтроку(СтрШаблон("%1Элемент.ИспользоватьВМеждународномУчете = %2;", Отступ, Элемент.ИспользоватьВМеждународномУчете));
		Код1С.ДобавитьСтроку(СтрШаблон("%1Элемент.ИспользоватьДляВыбора = %2;", Отступ, Элемент.ИспользоватьДляВыбора));
		Код1С.ДобавитьСтроку(СтрШаблон("%1Элемент.ИспользоватьВРеестреДокументов = %2;", Отступ, Элемент.ИспользоватьВРеестреДокументов));
		Код1С.ДобавитьСтроку(СтрШаблон("%1Элемент.ИспользоватьДляОграниченийДоступа = %2;", Отступ, Элемент.ИспользоватьДляОграниченийДоступа));

		Отбор = Новый Структура("Ссылка", Элемент.Ссылка);
		ЕстьПоказатели = (Булево(Элемент.ИспользоватьВМеждународномУчете) ИЛИ Булево(Элемент.ИспользоватьВБюджетировании)) 
			И НЕ ПустаяСтрока(Элемент.ИсточникДанных);
		Если ЕстьПоказатели Тогда
			Код1С.ДобавитьСтроку("");
			Код1С.ДобавитьСтроку(СтрШаблон("%1%2++ НЕ УТ", Отступ, ДвойнойОбратныйСлэш));
			Код1С.ДобавитьСтроку(СтрШаблон("%1ДобавитьПоказателиИсточника(Элемент, ТабличныеЧасти, Элемент.ИсточникДанных);", Отступ));
			Код1С.ДобавитьСтроку(СтрШаблон("%1%2-- НЕ УТ", Отступ, ДвойнойОбратныйСлэш));
		КонецЕсли;

		СвязанныеДокументы = ТабличныеЧасти.Документы.НайтиСтроки(Отбор);
		Если СвязанныеДокументы.Количество() > 0 Тогда
			Если НЕ ЕстьПоказатели Тогда
				Код1С.ДобавитьСтроку("");
			КонецЕсли;
			Код1С.ДобавитьСтроку(СтрШаблон("%1Элемент.Документы = ТабличныеЧасти.Документы.Скопировать();", Отступ));
			Для Каждого Документ Из СвязанныеДокументы Цикл
				Код1С.ДобавитьСтроку(СтрШаблон("%1Документ = Метаданные.Документы.Найти(""%2"");", Отступ, Документ.ИмяДокумента));
				Код1С.ДобавитьСтроку(СтрШаблон("%1Если Документ <> Неопределено Тогда", Отступ));
				Код1С.ДобавитьСтроку(СтрШаблон("	%1ЭлементТЧ = Элемент.Документы.Добавить();", Отступ));
				Код1С.ДобавитьСтроку(СтрШаблон("	%1ЭлементТЧ.ИмяДокумента = Документ.Имя;", Отступ));
				Код1С.ДобавитьСтроку(
					СтрШаблон("	%1НайденнаяСсылка = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Документ.ПолноеИмя());",
								Отступ));
				Код1С.ДобавитьСтроку(СтрШаблон("	%1ЭлементТЧ.ИдентификаторОбъектаМетаданных = НайденнаяСсылка;", Отступ));
				Код1С.ДобавитьСтроку(СтрШаблон("%1КонецЕсли;", Отступ));
			КонецЦикла;
		КонецЕсли;
		
		ФункциональныеОпции = ТабличныеЧасти.ФункциональныеОпции.НайтиСтроки(Отбор);
		Если ФункциональныеОпции.Количество() > 0 Тогда
			Если СвязанныеДокументы.Количество() > 0 ИЛИ (НЕ ЕстьПоказатели И СвязанныеДокументы.Количество() = 0) Тогда
				Код1С.ДобавитьСтроку("");
			КонецЕсли;
			Код1С.ДобавитьСтроку(СтрШаблон("%1Элемент.ФункциональныеОпции = ТабличныеЧасти.ФункциональныеОпции.Скопировать();", Отступ));
			Для Каждого Опция Из ФункциональныеОпции Цикл
				Код1С.ДобавитьСтроку(СтрШаблон("%1ЭлементТЧ = Элемент.ФункциональныеОпции.Добавить();", Отступ));
				Код1С.ДобавитьСтроку(СтрШаблон("%1ЭлементТЧ.ИмяФункциональнойОпции = ""%2"";", Отступ, Опция.ИмяФункциональнойОпции));
			КонецЦикла;
		КонецЕсли;
		
		Код1С.ДобавитьСтроку(СтрШаблон("%1#КонецОбласти %2%3" + Символы.ПС, Отступ, ДвойнойОбратныйСлэш, Элемент.ID));
		
	КонецЦикла;
	
КонецПроцедуры


// Описание
// 
// Возвращаемое значение:
// 	ДеревоЗначений - Описание:
// 	 *Ссылка - СправочникСсылка.НастройкиХозяйственныхОпераций - 
// 	 *ИмяПредопределенныхДанных - Строка -
// 	 *Наименование - Строка -
// 	 *Описание - Строка -
// 	 *ИсточникДанных - Строка -
// 	 *ПредставлениеИсточникаДанных - Строка -
// 	 *Приход - ПеречислениеСсылка.ТипыДанныхУчета - 
// 	 *Расход - ПеречислениеСсылка.ТипыДанныхУчета - 
// 	 *ИмяПредопределенныхДанных - Строка -
// 	 *ИспользоватьВБюджетировании - Строка -
// 	 *ИспользоватьВМеждународномУчете - Строка -
// 	 *ИспользоватьДляВыбора - Строка -
// 	 *ИспользоватьВРеестреДокументов - Строка -
// 	 *ИспользоватьДляОграниченийДоступа - Строка - 
// 	 *ЭтоГруппа - Булево -
&НаСервере
Функция НастройкиПредопределенныхЭлементов()
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Настройки.Ссылка КАК Ссылка,
	|	Настройки.ИмяПредопределенныхДанных КАК ID,
	|	Настройки.Наименование КАК Наименование,
	|	Настройки.Описание КАК Описание,
	|	Настройки.ИсточникДанных КАК ИсточникДанных,
	|	Настройки.ПредставлениеИсточникаДанных КАК ПредставлениеИсточникаДанных,
	|	Настройки.Приход КАК Приход,
	|	Настройки.Расход КАК Расход,
	|	Настройки.ИмяПредопределенныхДанных КАК ХозяйственнаяОперация,
	|	ВЫБОР
	|		КОГДА Настройки.ИспользоватьВБюджетировании
	|			ТОГДА ""Истина""
	|		ИНАЧЕ ""Ложь""
	|	КОНЕЦ КАК ИспользоватьВБюджетировании,
	|	ВЫБОР
	|		КОГДА Настройки.ИспользоватьВМеждународномУчете
	|			ТОГДА ""Истина""
	|		ИНАЧЕ ""Ложь""
	|	КОНЕЦ КАК ИспользоватьВМеждународномУчете,
	|	ВЫБОР
	|		КОГДА Настройки.ИспользоватьДляВыбора
	|			ТОГДА ""Истина""
	|		ИНАЧЕ ""Ложь""
	|	КОНЕЦ КАК ИспользоватьДляВыбора,
	|	ВЫБОР
	|		КОГДА Настройки.ИспользоватьВРеестреДокументов
	|			ТОГДА ""Истина""
	|		ИНАЧЕ ""Ложь""
	|	КОНЕЦ КАК ИспользоватьВРеестреДокументов,
	|	ВЫБОР
	|		КОГДА Настройки.ИспользоватьДляОграниченийДоступа
	|			ТОГДА ""Истина""
	|		ИНАЧЕ ""Ложь""
	|	КОНЕЦ КАК ИспользоватьДляОграниченийДоступа,
	|	Настройки.ЭтоГруппа КАК ЭтоГруппа
	|ИЗ
	|	Справочник.НастройкиХозяйственныхОпераций КАК Настройки
	|ГДЕ
	|	Настройки.Предопределенный
	|	И НЕ Настройки.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	Настройки.Наименование ИЕРАРХИЯ");
	
	Возврат Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	
КонецФункции

&НаСервере
Функция ПоказателиРегистра()
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ПоказателиРегистра.Ссылка КАК Ссылка,
	|	ПоказателиРегистра.Ссылка.ИмяПредопределенныхДанных КАК OwnerID,
	|	ПоказателиРегистра.Показатель КАК Показатель,
	|	ВЫБОР
	|		КОГДА ПоказателиРегистра.Использование
	|			ТОГДА ""Истина""
	|		ИНАЧЕ ""Ложь""
	|	КОНЕЦ КАК Использование
	|ИЗ
	|	Справочник.НастройкиХозяйственныхОпераций.ПоказателиРегистра КАК ПоказателиРегистра
	|ГДЕ
	|	НЕ ПоказателиРегистра.Ссылка.ЭтоГруппа
	|	И ПоказателиРегистра.Ссылка.Предопределенный
	|	И НЕ ПоказателиРегистра.Ссылка.ПометкаУдаления");
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

&НаСервере
Функция СвязанныеДокументы()
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	СвязанныеДокументы.Ссылка КАК Ссылка,
	|	СвязанныеДокументы.Ссылка.ИмяПредопределенныхДанных КАК OwnerID,
	|	ЕСТЬNULL(ИдентификаторыМетаданных.Имя, """") КАК ИмяДокумента,
	|	ЕСТЬNULL(ИдентификаторыМетаданных.Синоним, """") КАК ПредставлениеДокумента
	|ИЗ
	|	Справочник.НастройкиХозяйственныхОпераций.Документы КАК СвязанныеДокументы
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ИдентификаторыОбъектовМетаданных КАК ИдентификаторыМетаданных
	|		ПО (СвязанныеДокументы.ИдентификаторОбъектаМетаданных = ИдентификаторыМетаданных.Ссылка)
	|ГДЕ
	|	НЕ СвязанныеДокументы.Ссылка.ЭтоГруппа
	|	И СвязанныеДокументы.Ссылка.Предопределенный
	|	И НЕ СвязанныеДокументы.Ссылка.ПометкаУдаления");
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

&НаСервере
Функция ФункциональныеОпции()
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ФО.Ссылка КАК Ссылка,
	|	ФО.Ссылка.ИмяПредопределенныхДанных КАК OwnerID,
	|	ФО.ИмяФункциональнойОпции КАК ИмяФункциональнойОпции
	|ИЗ
	|	Справочник.НастройкиХозяйственныхОпераций.ФункциональныеОпции КАК ФО
	|ГДЕ
	|	НЕ ФО.Ссылка.ЭтоГруппа
	|	И ФО.Ссылка.Предопределенный
	|	И НЕ ФО.Ссылка.ПометкаУдаления");
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

&НаСервере
Процедура ЗаполнитьНастройкиНаСервере()
	
	Справочники.НастройкиХозяйственныхОпераций.ЗаполнитьПредопределенныеНастройкиХозяйственныхОпераций();
	
КонецПроцедуры

#КонецОбласти