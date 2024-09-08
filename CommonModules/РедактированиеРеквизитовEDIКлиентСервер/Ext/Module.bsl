﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// В модуле реализованы клиент-серверные процедуры и функции, предназначенные для управления
//  доступностью редактирования реквизитов EDI
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определяет доступность реквизита, участвующего в обмене EDI, на редактирование
// 
// Параметры:
// 	Форма        - ФормаКлиентскогоПриложения - Форма документа, участвующего в обмене по EDI
// 	ИмяРеквизита - Строка                     - Строковый идентификатор реквизита
// Возвращаемое значение:
// 	Булево - Истина - если реквизит доступен для редактирования
//           Ложь   - в ином случае.
Функция РеквизитДоступенДляРедактирования(Форма, ИмяРеквизита) Экспорт
	
	Если Не ДокументыEDIИнтеграцияКлиентСервер.ФормаИнициализирована(Форма) Тогда
		Возврат Истина;
	ИначеЕсли ПустаяСтрока(Форма.СвойстваEDI.ДанныеСтатусаДокумента.ИдентификаторВСервисе) Тогда
		Возврат Истина;
	Иначе
		Возврат Не Форма.СвойстваEDI.ДанныеСтатусаДокумента.ДоступныеРеквизиты.Найти(ИмяРеквизита) = Неопределено;
	КонецЕсли;
	
КонецФункции

#КонецОбласти 
