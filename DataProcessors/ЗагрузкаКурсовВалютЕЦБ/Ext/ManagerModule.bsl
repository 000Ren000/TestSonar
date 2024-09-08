﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Процедура ЗагрузитьАктуальныйКурс(ПараметрыЗагрузки = Неопределено, АдресРезультата = Неопределено) Экспорт
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания(Метаданные.РегламентныеЗадания.ЗагрузкаКурсовВалютЕЦБ);
	
	ИмяСобытия = ИмяСобытияЖурналаРегистрации();
	
	ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Информация, , ,
		НСтр("ru = 'Начата регламентная загрузка курсов валют ЕЦБ'"));
		
	БазоваяВалюта = Справочники.Валюты.НайтиПоКоду("978");
	Если Не ЗначениеЗаполнено(БазоваяВалюта) Тогда
		ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка,,,
		НСтр("ru = 'Во время регламентной загрузки курсов валют ЕЦБ возникли ошибки. В справочнике ""Валюты"" отсутсвует Евро (EUR).'"));
		Если ПараметрыЗагрузки = Неопределено Тогда 
			ВызватьИсключение НСтр("ru = 'Загрузка курсов ЕЦБ не выполнена. В справочнике ""Валюты"" отсутсвует Евро (EUR).'");
		КонецЕсли;
	КонецЕсли;
	
	ТекущаяДата = ТекущаяДатаСеанса();
	
	ПриЗагрузкеВозниклиОшибки = Ложь;
	
	Если ПараметрыЗагрузки = Неопределено Тогда
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	КурсыВалют.Валюта КАК Валюта,
		|	МАКСИМУМ(КурсыВалют.Период) КАК ДатаКурса
		|ПОМЕСТИТЬ ВТ_Курсы
		|ИЗ
		|	РегистрСведений.ОтносительныеКурсыВалют КАК КурсыВалют
		|ГДЕ
		|	КурсыВалют.Валюта.СпособУстановкиКурса = ЗНАЧЕНИЕ(Перечисление.СпособыУстановкиКурсаВалюты.ЗагрузкаИзИнтернета)
		|	И КурсыВалют.Валюта.ПометкаУдаления = ЛОЖЬ
		|	И КурсыВалют.БазоваяВалюта = &БазоваяВалюта
		|	И КурсыВалют.Валюта <> КурсыВалют.БазоваяВалюта
		|
		|СГРУППИРОВАТЬ ПО
		|	КурсыВалют.Валюта
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Валюты.Ссылка КАК Валюта,
		|	Валюты.Код КАК Код,
		|	ЕСТЬNULL(ВТ_Курсы.ДатаКурса, ДАТАВРЕМЯ(1980, 1, 1)) КАК ДатаКурса
		|ИЗ
		|	Справочник.Валюты КАК Валюты
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Курсы КАК ВТ_Курсы
		|		ПО Валюты.Ссылка = ВТ_Курсы.Валюта
		|ГДЕ
		|	Валюты.СпособУстановкиКурса = ЗНАЧЕНИЕ(Перечисление.СпособыУстановкиКурсаВалюты.ЗагрузкаИзИнтернета)
		|	И Валюты.ПометкаУдаления = ЛОЖЬ
		|	И Валюты.Ссылка <> &БазоваяВалюта";
		
		Запрос = Новый Запрос(ТекстЗапроса);
		Запрос.УстановитьПараметр("БазоваяВалюта", БазоваяВалюта);
		РезультатЗапроса = Запрос.Выполнить();
		
		Если Не РезультатЗапроса.Пустой() Тогда
			
			Выборка = Запрос.Выполнить().Выбрать();
			
			КонецПериода = ТекущаяДата;
			НачалоПериода = КонецПериода;
			Пока Выборка.Следующий() Цикл
				НачалоПериода = Мин(НачалоПериода, ?(Выборка.ДатаКурса = '198001010000', НачалоГода(ДобавитьМесяц(ТекущаяДата, -12)), Выборка.ДатаКурса + 60*60*24));
				СписокВалют = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Выборка);
				ЗагрузитьКурсыВалютПоПараметрам(СписокВалют, НачалоПериода, КонецПериода, БазоваяВалюта, ПриЗагрузкеВозниклиОшибки, Истина);
			КонецЦикла;
			
		КонецЕсли;
	Иначе
		Результат = ЗагрузитьКурсыВалютПоПараметрам(ПараметрыЗагрузки.СписокВалют,
			ПараметрыЗагрузки.НачалоПериода, ПараметрыЗагрузки.КонецПериода, БазоваяВалюта, ПриЗагрузкеВозниклиОшибки);
	КонецЕсли;
		
	Если АдресРезультата <> Неопределено Тогда
		ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	КонецЕсли;

	Если ПриЗагрузкеВозниклиОшибки Тогда
		ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка,,,
			НСтр("ru = 'Во время регламентной загрузки курсов валют ЕЦБ возникли ошибки'"));
		Если ПараметрыЗагрузки = Неопределено Тогда
			ВызватьИсключение НСтр("ru = 'Загрузка курсов ЕЦБ не выполнена.'");
		КонецЕсли;
	Иначе
		ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Информация,,,
			НСтр("ru = 'Завершена регламентная загрузка курсов валют ЕЦБ.'"));
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьСоответсвие(Соответствие, ДатаКурса, СписокКурсовXDTO, МассивВалютДляЗагрузки, Знач РазделительДробнойЧасти)
	
	КурсыДень = Новый Соответствие;
	
	Для Каждого Курс Из СписокКурсовXDTO Цикл
		
		ЗагружаемаяВалюта = Справочники.Валюты.НайтиПоНаименованию(СокрЛП(Курс.currency));
		
		Если МассивВалютДляЗагрузки.Найти(ЗагружаемаяВалюта) <> Неопределено Тогда
			КурсыДень.Вставить(ЗагружаемаяВалюта, ТекстВЧисло(Курс.rate, РазделительДробнойЧасти));
		КонецЕсли;
		
	КонецЦикла;
	
	Соответствие.Вставить(ДатаКурса, КурсыДень);
	
КонецПроцедуры

Функция ПолучитьДанныеКурсов(XDTO, НачалоПериодаЗагрузки, ОкончаниеПериодаЗагрузки, МассивВалютДляЗагрузки, Знач РазделительДробнойЧасти)
	
	Если ТипЗнч(XDTO) = Тип("ОбъектXDTO") И XDTO.Свойства().Получить("time") <> Неопределено Тогда
		
		Соответствие = Новый Соответствие;
		
		ДатаКурса = Дата(СтрЗаменить(XDTO["time"], "-", ""));
		
		Если ДатаКурса <= ОкончаниеПериодаЗагрузки И ДатаКурса >= НачалоПериодаЗагрузки Тогда 
			ЗаполнитьСоответсвие(Соответствие, ДатаКурса, XDTO["Cube"], МассивВалютДляЗагрузки, РазделительДробнойЧасти);
		Иначе
			Соответствие.Вставить(ДатаКурса, Неопределено);
		КонецЕсли;
			
		Возврат Соответствие;
		
	ИначеЕсли ТипЗнч(XDTO) = Тип("СписокXDTO") Тогда
		
		Соответствие = Новый Соответствие;
		
		Для Каждого СпискоДат Из XDTO Цикл
			
			ДатаКурса = Дата(СтрЗаменить(СпискоДат.time, "-", ""));
			
			Если ДатаКурса > ОкончаниеПериодаЗагрузки Тогда
				Продолжить;
			КонецЕсли;
			
			Если ДатаКурса < НачалоПериодаЗагрузки Тогда 
				Прервать;
			КонецЕсли;
			
			ЗаполнитьСоответсвие(Соответствие, ДатаКурса, СпискоДат.Cube, МассивВалютДляЗагрузки, РазделительДробнойЧасти);
			
		КонецЦикла;
		
		Возврат Соответствие;
		
	Иначе
		Возврат	ПолучитьДанныеКурсов(XDTO.Cube, НачалоПериодаЗагрузки, ОкончаниеПериодаЗагрузки, МассивВалютДляЗагрузки, РазделительДробнойЧасти);
	КонецЕсли;
	
КонецФункции

Функция ПрочитатьФайлКурсов(Файл, НачалоПериодаЗагрузки, ОкончаниеПериодаЗагрузки, МассивВалютДляЗагрузки, Знач РазделительДробнойЧасти)
	
	Текст = Новый ТекстовыйДокумент();
	Текст.Прочитать(Файл.Путь, КодировкаТекста.UTF8);
	
	Чтение = Новый ЧтениеXML;
	Чтение.УстановитьСтроку(Текст.ПолучитьТекст());
	
	Фабрика = ФабрикаXDTO.ПрочитатьXML(Чтение);
	
	ДанныеКурсов = ПолучитьДанныеКурсов(Фабрика, НачалоПериодаЗагрузки, ОкончаниеПериодаЗагрузки, МассивВалютДляЗагрузки, РазделительДробнойЧасти);
	
	Если ЭтоАдресВременногоХранилища(Файл.Путь) Тогда
		УдалитьИзВременногоХранилища(Файл.Путь);
	КонецЕсли;
	
	УдалитьФайлы(Файл.Путь);

	Возврат ДанныеКурсов;
	
КонецФункции

Функция ЗагрузитьКурсыВалютПоПараметрам(Знач Валюты, Знач НачалоПериодаЗагрузки, Знач ОкончаниеПериодаЗагрузки, БазоваяВалюта, ПриЗагрузкеВозниклиОшибки = Ложь, ДатаКурсаВалютыВКоллекции = Ложь)
	
	СостояниеЗагрузки = Новый Массив;
	
	РазницаДатЗагрузки = (ОкончаниеПериодаЗагрузки - НачалоПериодаЗагрузки)/86400; 
	ШаблонСерверИсточник = "https://www.ecb.europa.eu/stats/eurofxref/eurofxref-%1.xml";
	Если РазницаДатЗагрузки = 1 И НачалоДня(ОкончаниеПериодаЗагрузки) = НачалоДня(ТекущаяДатаСеанса()) Тогда
		ФайлНаВебСервере = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСерверИсточник, "daily");
	ИначеЕсли РазницаДатЗагрузки < 89 Тогда
		ФайлНаВебСервере = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСерверИсточник, "hist-90d");
	Иначе
		ФайлНаВебСервере = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСерверИсточник, "hist");
	КонецЕсли;

	Результат = ПолучениеФайловИзИнтернета.СкачатьФайлНаСервере(ФайлНаВебСервере);
	Если Результат.Статус Тогда
		ВалютыЗагружаемыеИзИнтернета = ВалютыЗагружаемыеИзИнтернета();
		РазделительДробнойЧасти = ЛокальныйРазделительДробнойЧасти();
		ДанныеКурсов = ПрочитатьФайлКурсов(Результат, НачалоПериодаЗагрузки, ОкончаниеПериодаЗагрузки, ВалютыЗагружаемыеИзИнтернета, РазделительДробнойЧасти);
	Иначе
		ПоясняющееСообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Невозможно получить файл данных с курсами валют ЕЦБ.
				|Возможно, нет доступа к веб-сайту с курсами валют. Код состояния %1'"),
				Результат.КодСостояния);
		ПриЗагрузкеВозниклиОшибки = Истина;
		СостояниеЗагрузки.Добавить(Новый Структура("Операция,СтатусОперации,Сообщение", НСтр("ru = 'Скачивание файла данных'"), Ложь, ПоясняющееСообщение));
		
		Возврат СостояниеЗагрузки;
		
	КонецЕсли;
	
	Если ДатаКурсаВалютыВКоллекции = Ложь Тогда
		МассивДатЗагрузки = ОбщегоНазначенияУТ.МассивДатИзПериода(НачалоПериодаЗагрузки, ОкончаниеПериодаЗагрузки);
	КонецЕсли;
		
	Для Каждого Валюта Из Валюты Цикл
		Если ВалютыЗагружаемыеИзИнтернета.Найти(Валюта.Валюта) = Неопределено Тогда
			ПриЗагрузкеВозниклиОшибки = Истина;
			СтатусОперации = Ложь;
			ПоясняющееСообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Невозможно получить файл данных с курсами валюты %2 (код %1):
					|Курсы данной валюты не предоставляются.'"),
				Валюта.КодВалюты,
				Валюта.Валюта);
				
			ЗаписьЖурналаРегистрации(ИмяСобытияЖурналаРегистрации(), УровеньЖурналаРегистрации.Ошибка, , , ПоясняющееСообщение);
		Иначе
			Если ДатаКурсаВалютыВКоллекции Тогда
				МассивДатЗагрузки = ОбщегоНазначенияУТ.МассивДатИзПериода(Валюта.ДатаКурса, ОкончаниеПериодаЗагрузки);
			КонецЕсли;
			ПоясняющееСообщение = ЗагрузитьКурсВалюты(Валюта.Валюта, ДанныеКурсов, МассивДатЗагрузки, БазоваяВалюта) + Символы.ПС;
			СтатусОперации = ПустаяСтрока(ПоясняющееСообщение);
		КонецЕсли;
		СостояниеЗагрузки.Добавить(Новый Структура("Валюта,СтатусОперации,Сообщение", Валюта.Валюта, СтатусОперации, ПоясняющееСообщение));
	КонецЦикла;
			
	Возврат СостояниеЗагрузки;
	
КонецФункции

Функция ЗагрузитьКурсВалюты(Знач Валюта, Знач ДанныеКурсов, Знач МассивДатЗагрузки, Знач БазоваяВалюта)
	
	СписокОшибок = Новый Массив;
	
	Для Каждого ДатаКурса Из МассивДатЗагрузки Цикл
		
		ДанныеНаДату = ДанныеКурсов.Получить(ДатаКурса); //Соответствие
		Если ДанныеНаДату = Неопределено Тогда
			СписокОшибок.Добавить(СтрШаблон(НСтр("ru = 'Для валюты %1 на %2 на сервере нет данных для загрузки'"), Строка(Валюта), Формат(ДатаКурса, "ДЛФ=DD")));
			Продолжить;
		КонецЕсли;
		
		Курс = ДанныеНаДату.Получить(Валюта);
		Если Не ЗначениеЗаполнено(Курс) Тогда
			СписокОшибок.Добавить(СтрШаблон(НСтр("ru = 'Для валюты %1 на %2 на сервере нет данных для загрузки'"), Строка(Валюта),  Формат(ДатаКурса, "ДЛФ=DD")));
			Продолжить;
		КонецЕсли;
		
		НаборЗаписей = РегистрыСведений.ОтносительныеКурсыВалют.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Валюта.Установить(Валюта);
		НаборЗаписей.Отбор.БазоваяВалюта.Установить(БазоваяВалюта);
		НаборЗаписей.Отбор.Период.Установить(ДатаКурса);
		Запись = НаборЗаписей.Добавить();
		Запись.Валюта = Валюта;
		Запись.БазоваяВалюта = БазоваяВалюта;
		Запись.Период = ДатаКурса;
		Запись.КурсЧислитель = 1;
		Запись.КурсЗнаменатель = Курс;
		
		НаборЗаписей.Записать();
		
	КонецЦикла;
	
	СообщенияПользователю = ПолучитьСообщенияПользователю(Истина);
	Для Каждого СообщениеПользователю Из СообщенияПользователю Цикл
		СписокОшибок.Добавить(СообщениеПользователю.Текст);
	КонецЦикла;
	СписокОшибок = ОбщегоНазначенияКлиентСервер.СвернутьМассив(СписокОшибок);
	
	Возврат СтрСоединить(СписокОшибок, Символы.ПС);
	
КонецФункции

Функция ВалютыЗагружаемыеИзИнтернета()
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Валюты.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Валюты КАК Валюты
	|ГДЕ
	|	НЕ Валюты.ПометкаУдаления
	|	И Валюты.СпособУстановкиКурса = ЗНАЧЕНИЕ(Перечисление.СпособыУстановкиКурсаВалюты.ЗагрузкаИзИнтернета)";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Результат = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	Возврат Результат;
	
КонецФункции

Функция ИмяСобытияЖурналаРегистрации()
	Возврат НСтр("ru = 'Загрузка курсов валют ЕЦБ'", ОбщегоНазначения.КодОсновногоЯзыка());
КонецФункции

Функция ЛокальныйРазделительДробнойЧасти()
	
	ПроверочноеЧисло = 1.5;
	ПроверочноеЧислоСтрокой = Строка(ПроверочноеЧисло);
	Возврат Сред(ПроверочноеЧислоСтрокой, 2, 1);
	
КонецФункции

Функция ТекстВЧисло(Знач СтроковоеЗначение, Знач РазделительДробнойЧасти)
	
	Результат = Неопределено;
	
	СтроковоеЗначение = СтрЗаменить(СтроковоеЗначение, ".", РазделительДробнойЧасти);
	
    Результат = Число(СтроковоеЗначение);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли
