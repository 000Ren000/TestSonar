﻿
#Область ОбработчикиСобытийФормы
// Код процедур и функций

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	Сотрудник = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Пользователи.ТекущийПользователь(), "ФизическоеЛицо");
	ПоказыватьФотоТоваров = Параметры.ПоказыватьФотоТоваров;
	ТекущийСклад = Параметры.ТекущийСклад;
	ТипСотрудника = Обработки.МобильноеРабочееМестоСборкиИКурьерскойДоставки.ТипСотрудникаСборщик();
	ОбновитьДанныеФормыСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СфомироватьПредставлениеОтборов();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ВРег(ИсточникВыбора.ИмяФормы) = ВРег("Справочник.Склады.Форма.ФормаВыбора") Тогда
		
		ТекущийСклад = ВыбранноеЗначение;
		СфомироватьПредставлениеОтборов();
		ОбновитьДанныеФормы();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокРаспоряженийНазначенныеМне

&НаКлиенте
Процедура СписокРаспоряженийНазначенныеМнеВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущаяСтрока = Элементы.СписокРаспоряженийНазначенныеМне.ТекущиеДанные;
	
	ПараметрыОткрытияФормы = Новый Структура;
	ПараметрыОткрытияФормы.Вставить("Заказ", Элемент.ТекущиеДанные.Распоряжение);
	ПараметрыОткрытияФормы.Вставить("ПоказыватьФотоТоваров", ПоказыватьФотоТоваров);
	
	Описание = Новый ОписаниеОповещения("ОбновитьДанныеФормы", ЭтаФорма);
	
	ОткрытьФорму(
	"Обработка.МобильноеРабочееМестоСборкиИКурьерскойДоставки.Форма.РабочееМестоСборщика",
	ПараметрыОткрытияФормы,
	ЭтаФорма,,,,Описание,
	РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтборыОчистить(Команда)
	
	ТекущийСклад = Неопределено;
	СфомироватьПредставлениеОтборов();
	ОбновитьДанныеФормы();

КонецПроцедуры

&НаКлиенте
Процедура ОтборыОткрыть(Команда)
	
	ПараметрыОткрытияФормы = Новый Структура;
	ПараметрыОткрытияФормы.Вставить("РежимВыбора", Истина);
	ПараметрыОткрытияФормы.Вставить("МножественныйВыбор", Ложь);
	ПараметрыОткрытияФормы.Вставить("ЗакрыватьПриВыборе", Истина);
	ПараметрыОткрытияФормы.Вставить("Отбор", Новый Структура("Ссылка", ДоступныеСклады()));
		
	ОткрытьФорму(
		"Справочник.Склады.Форма.ФормаВыбора",
		ПараметрыОткрытияФормы,
		ЭтаФорма,,,,,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ВзятьВРаботу(Команда)
	
	ТекущаяСтрока = Элементы.СписокРаспоряженийНераспределенные.ТекущиеДанные;
	НазначитьСнятьСотрудника(ТекущаяСтрока.Распоряжение, ТипСотрудника, Сотрудник);
	
КонецПроцедуры

&НаСервере
Процедура НазначитьСнятьСотрудника(Распоряжение, ТипСотрудника, Сотрудник = Неопределено);
	
	Обработки.МобильноеРабочееМестоСборкиИКурьерскойДоставки.НазначитьСнятьСотрудника(Распоряжение,
									ТипСотрудника,
									Сотрудник);
	ОбновитьДанныеФормыСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьСМеня(Команда)
	
	ТекущаяСтрока = Элементы.СписокРаспоряженийНазначенныеМне.ТекущиеДанные;
	НазначитьСнятьСотрудника(ТекущаяСтрока.Распоряжение, ТипСотрудника);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьФорму(Команда)
	ОбновитьДанныеФормы();
	СфомироватьПредставлениеОтборов();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьДанныеФормы(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	ОбновитьДанныеФормыСервер();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДанныеФормыСервер()
	
	ЗаполнитьСписокРаспоряжений();
	ЗаполнитьСтатистикуСборки();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтатистикуСборки()
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	СтатусыСборкиИДоставки.Статус КАК Статус,
	               |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ СтатусыСборкиИДоставки.Распоряжение) КАК Количество
	               |ИЗ
	               |	РегистрСведений.СтатусыСборкиИДоставки КАК СтатусыСборкиИДоставки
	               |ГДЕ
	               |	СтатусыСборкиИДоставки.Распоряжение.Сборщик = &Сотрудник
	               |	И СтатусыСборкиИДоставки.Статус В(&СтатусыКСборкеСобирается)
	               |	И (&Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
	               |			ИЛИ СтатусыСборкиИДоставки.Распоряжение.Склад В ИЕРАРХИИ (&Склад))
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	СтатусыСборкиИДоставки.Статус
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	МАКСИМУМ(ЕСТЬNULL(СтатусыСборкиИДоставки.ДатаСборки, ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0))) КАК ДатаСборки,
	               |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ СтатусыСборкиИДоставки.Распоряжение) КАК Количество
	               |ИЗ
	               |	РегистрСведений.СтатусыСборкиИДоставки КАК СтатусыСборкиИДоставки
	               |ГДЕ
	               |	СтатусыСборкиИДоставки.Распоряжение.Сборщик = &Сотрудник
	               |	И СтатусыСборкиИДоставки.ДатаСборки МЕЖДУ &НачалоПериода И &КонецПериода
	               |	И (&Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
	               |			ИЛИ СтатусыСборкиИДоставки.Распоряжение.Склад В ИЕРАРХИИ (&Склад))";
	
	Запрос.УстановитьПараметр("Сотрудник", Сотрудник);
	Запрос.УстановитьПараметр("Склад", ТекущийСклад);
	Запрос.УстановитьПараметр("НачалоПериода", НачалоДня(ТекущаяДатаСеанса()));
	Запрос.УстановитьПараметр("КонецПериода", КонецДня(ТекущаяДатаСеанса()));
	
	СтатусыКСборкеСобирается = Новый Массив;
	СтатусыКСборкеСобирается.Добавить(СкладыСервер.СтатусЗаказаКСборке());
	СтатусыКСборкеСобирается.Добавить(СкладыСервер.СтатусЗаказаСобирается());
	
	
	Запрос.УстановитьПараметр("СтатусыКСборкеСобирается", СтатусыКСборкеСобирается);
	
	Результаты = Запрос.ВыполнитьПакет();
	
	ВыборкаВРаботе = Результаты[0].Выбрать();
	ВыборкаСобрано = Результаты[1].Выгрузить();
	
	КСборке = 0;
	Собирается = 0;
	Собрано = 0;
	ДатаПоследнейСборки = Дата('0001,01,01');
	
	Пока ВыборкаВРаботе.Следующий() Цикл
		
		Если ВыборкаВРаботе.Статус = Перечисления.СтатусыСборкиИДоставки.КСборке Тогда
			КСборке = ВыборкаВРаботе.Количество;
		Иначе
			Собирается = ВыборкаВРаботе.Количество;
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого СтрокаВыборкаСобрано Из ВыборкаСобрано Цикл
		
		ДатаПоследнейСборки = СтрокаВыборкаСобрано.ДатаСборки;
		Собрано = СтрокаВыборкаСобрано.Количество;
		
	КонецЦикла;
	
	Элементы.НазначеноКоличество.Заголовок = КСборке;
	Элементы.СобираетсяКоличество.Заголовок = Собирается;
	Элементы.СобраноКоличество.Заголовок = Собрано;
	Если ДатаПоследнейСборки = Дата('0001,01,01') Тогда
		Элементы.ПоследнийВремя.Заголовок = " нет";
	Иначе
		Элементы.ПоследнийВремя.Заголовок = " в " + Формат(ДатаПоследнейСборки,"ДФ=HH:mm");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокРаспоряжений()
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СотрудникиМагазинов.Склад КАК Склад
	|ПОМЕСТИТЬ ДоступныеСклады
	|ИЗ
	|	РегистрСведений.СотрудникиМагазинов КАК СотрудникиМагазинов
	|ГДЕ
	|	СотрудникиМагазинов.Сотрудник = &Сотрудник
	|	И СотрудникиМагазинов.Сборщик
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СтатусыСборкиИДоставки.Распоряжение КАК Распоряжение,
	|	СтатусыСборкиИДоставки.Статус КАК Статус,
	|	Документы.Склад КАК Склад,
	|	Документы.Сборщик КАК Сборщик,
	|	Документы.Номер КАК Номер,
	|	Документы.ДатаОтгрузки КАК ДатаДоставки,
	|	Документы.ВремяДоставкиС КАК ВремяДоставкиС,
	|	Документы.ВремяДоставкиПо КАК ВремяДоставкиПо,
	|	Документы.СуммаДокумента КАК СуммаДокумента,
	|	0 КАК СуммаКОплате,
	|	Документы.АдресДоставки КАК АдресДоставкиПредставление,
	|	Документы.АдресДоставкиЗначенияПолей КАК АдресДоставкиЗначенияПолей,
	|	Документы.ДополнительнаяИнформацияПоДоставке КАК ДополнительнаяИнформацияПоДоставке,
	|	Документы.Валюта КАК Валюта,
	|	Документы.ФормаОплаты КАК ФормаОплаты,
	|	NULL КАК Дата,
	|	СтатусыСборкиИДоставки.КоличествоСтрокВЗаказе КАК КоличествоСтрок,
	|	СтатусыСборкиИДоставки.КоличествоСтрокВЗаказе КАК КоличествоСтрокВЗаказе,
	|	СтатусыСборкиИДоставки.КоличествоСтрокСобрано КАК КоличествоСтрокСобрано
	|ПОМЕСТИТЬ ВсеРаспоряжения
	|ИЗ
	|	РегистрСведений.СтатусыСборкиИДоставки КАК СтатусыСборкиИДоставки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаказКлиента КАК Документы
	|		ПО ((ВЫРАЗИТЬ(СтатусыСборкиИДоставки.Распоряжение КАК Документ.ЗаказКлиента)) = Документы.Ссылка)
	|ГДЕ
	|	СтатусыСборкиИДоставки.Статус В(&Статусы)
	|	И Документы.Сборщик = &Сотрудник
	|	И Документы.Проведен
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	СтатусыСборкиИДоставки.Распоряжение,
	|	СтатусыСборкиИДоставки.Статус,
	|	Документы.Склад,
	|	Документы.Сборщик,
	|	Документы.Номер,
	|	NULL,
	|	Документы.ВремяДоставкиС,
	|	Документы.ВремяДоставкиПо,
	|	Документы.СуммаДокумента,
	|	0,
	|	Документы.АдресДоставки,
	|	Документы.АдресДоставкиЗначенияПолей,
	|	Документы.ДополнительнаяИнформацияПоДоставке,
	|	Документы.Валюта,
	|	Документы.ФормаОплаты,
	|	Документы.Дата,
	|	СтатусыСборкиИДоставки.КоличествоСтрокВЗаказе КАК КоличествоСтрок,
	|	СтатусыСборкиИДоставки.КоличествоСтрокВЗаказе,
	|	СтатусыСборкиИДоставки.КоличествоСтрокСобрано
	|ИЗ
	|	РегистрСведений.СтатусыСборкиИДоставки КАК СтатусыСборкиИДоставки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РеализацияТоваровУслуг КАК Документы
	|		ПО ((ВЫРАЗИТЬ(СтатусыСборкиИДоставки.Распоряжение КАК Документ.РеализацияТоваровУслуг)) = Документы.Ссылка)
	|ГДЕ
	|	СтатусыСборкиИДоставки.Статус В(&Статусы)
	|	И Документы.Сборщик = &Сотрудник
	|	И Документы.Проведен
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА Распоряжения.Сборщик = &Сотрудник
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК НазначеноеМне,
	|	ВЫБОР
	|		КОГДА Распоряжения.Сборщик = ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
	|				И НЕ ДоступныеСклады.Склад ЕСТЬ NULL
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК Нераспределенное,
	|	Распоряжения.Распоряжение КАК Распоряжение,
	|	Распоряжения.Статус КАК Статус,
	|	Распоряжения.Склад КАК Склад,
	|	Распоряжения.Сборщик КАК Сборщик,
	|	Распоряжения.Номер КАК Номер,
	|	Распоряжения.ДатаДоставки КАК ДатаДоставки,
	|	Распоряжения.ВремяДоставкиС КАК ВремяДоставкиС,
	|	Распоряжения.ВремяДоставкиПо КАК ВремяДоставкиПо,
	|	Распоряжения.СуммаДокумента КАК СуммаДокумента,
	|	Распоряжения.СуммаКОплате КАК СуммаКОплате,
	|	Распоряжения.АдресДоставкиПредставление КАК АдресДоставкиПредставление,
	|	Распоряжения.АдресДоставкиЗначенияПолей КАК АдресДоставкиЗначенияПолей,
	|	Распоряжения.ДополнительнаяИнформацияПоДоставке КАК Комментарий,
	|	Распоряжения.Валюта КАК Валюта,
	|	Распоряжения.ФормаОплаты КАК ФормаОплаты,
	|	Распоряжения.Дата КАК Дата,
	|	Распоряжения.КоличествоСтрок КАК КоличествоСтрок,
	|	Распоряжения.КоличествоСтрокВЗаказе КАК КоличествоСтрокВЗаказе,
	|	Распоряжения.КоличествоСтрокСобрано КАК КоличествоСтрокСобрано
	|ИЗ
	|	ВсеРаспоряжения КАК Распоряжения
	|		ЛЕВОЕ СОЕДИНЕНИЕ ДоступныеСклады КАК ДоступныеСклады
	|		ПО Распоряжения.Склад = ДоступныеСклады.Склад
	|ГДЕ
	|	(Распоряжения.Сборщик = &Сотрудник
	|			ИЛИ НЕ ДоступныеСклады.Склад ЕСТЬ NULL)
	|	И (&Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
	|			ИЛИ Распоряжения.Склад В ИЕРАРХИИ (&Склад))
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаДоставки,
	|	ВремяДоставкиПо";
	
	Запрос.УстановитьПараметр("Сотрудник", Сотрудник);
	Запрос.УстановитьПараметр("Склад", ТекущийСклад);
	Запрос.УстановитьПараметр("Дата", ТекущаяДатаСеанса());
	Запрос.УстановитьПараметр("Статусы", СкладыСервер.СтатусЗаказаСобирается());
	
	Результаты = Запрос.ВыполнитьПакет();
	
	ВыборкаПоРаспоряжениям = Результаты[2].Выбрать();
	
	СписокРаспоряжений.Очистить();
	
	Пока ВыборкаПоРаспоряжениям.Следующий() Цикл
		
		НоваяСтрока = СписокРаспоряжений.Добавить();
		
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаПоРаспоряжениям);
		
		Если ЗначениеЗаполнено(НоваяСтрока.Комментарий) Тогда
			НоваяСтрока.КомментарийКартинка = БиблиотекаКартинок.КомментарийКрасныйДоставка;
		КонецЕсли;
		
		Модуль = Обработки.МобильноеРабочееМестоСборкиИКурьерскойДоставки;
		
		НоваяСтрока.ДатаВремяДоставкиПредставление = Модуль.ДатаВремяДоставкиПредставление(НоваяСтрока);
		НоваяСтрока.ОсталосьВремениНаДоставку = Модуль.ОсталосьВремениНаДоставку(НоваяСтрока);
		НоваяСтрока.СуммаПредставление = Модуль.СуммаПредставление(НоваяСтрока);
		НоваяСтрока.ФормаОплатыПредставление = Модуль.ФормаОплатыПредставление(НоваяСтрока);
		
		НоваяСтрока.КоличествоСтрок = Строка(ВыборкаПоРаспоряжениям.КоличествоСтрокСобрано) + "/" + Строка(ВыборкаПоРаспоряжениям.КоличествоСтрокВЗаказе);
		
	КонецЦикла;
	
	КоличествоРаспоряженийПоСкладу = СписокРаспоряжений.Количество();
	
КонецПроцедуры

&НаСервере
Процедура СфомироватьПредставлениеОтборов()
	
	ПредставленияОтборов = "";
	Если ЗначениеЗаполнено(ТекущийСклад) Тогда
		ПредставленияОтборов = ТекущийСклад;
		Элементы.КомандаОтборыОткрыть.ЦветТекста = WebЦвета.Черный;
		Элементы.ГруппаКомандаОтборыКоличествоОчистить.Видимость = Истина;
		Элементы.РамкаОтборыОткрыть.Картинка = БиблиотекаКартинок.РамкаМенюЧерная;
	Иначе
		ПредставленияОтборов = НСтр("ru='Выбрать магазин/склад'");
		Элементы.КомандаОтборыОткрыть.ЦветТекста = WebЦвета.ТемноСерый;
		Элементы.ГруппаКомандаОтборыКоличествоОчистить.Видимость = Ложь;
		Элементы.РамкаОтборыОткрыть.Картинка = БиблиотекаКартинок.РамкаМенюСерая;
	КонецЕсли;
	
	Элементы.КомандаОтборыОткрыть.Заголовок = ПредставленияОтборов;
	
КонецПроцедуры

&НаСервере
Функция ДоступныеСклады()
	
	Возврат СкладыСервер.ДоступныеСкладыСотрудникаПоТипуСотрудника(Сотрудник, ТипСотрудника);
	
КонецФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокРаспоряженийНазначенныеМнеСтатус.Имя);
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокРаспоряженийНазначенныеМне.Статус");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.СтатусыСборкиИДоставки.ГотовКДоставке;
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаСтатусаГотовСборкаИДоставка);

	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокРаспоряженийНазначенныеМнеОсталосьВремениНаДоставку.Имя);
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокРаспоряженийНазначенныеМне.Опоздание");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаОтрицательныхЗначений);
	
КонецПроцедуры

#КонецОбласти
